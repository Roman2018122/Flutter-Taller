// lib/data/repository/auth_repository_impl.dart

import 'package:dio/dio.dart';
import '../../domain/model/auth_models.dart';
import '../../domain/repository/auth_repository.dart';
import '../local/secure_storage.dart';
import '../remote/api/dio_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;
  final SecureStorage _secureStorage;

  AuthRepositoryImpl({
    required DioClient dioClient,
    required SecureStorage secureStorage,
  }) : _dioClient = dioClient,
       _secureStorage = secureStorage;

  @override
  Future<LoggedUser> login({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Apunta a tu endpoint de login (ajusta '/token/' si tu url de SimpleJWT es diferente)
      final response = await _dioClient.dio.post(
        '/token/',
        data: {'username': username, 'password': password},
      );

      // 2. Extrae los tokens JWT que devuelve Django
      final accessToken = response.data['access'] as String;
      final refreshToken = response.data['refresh'] as String;

      // 3. Los guarda de forma cifrada en el almacenamiento del celular
      await _secureStorage.saveTokens(
        access: accessToken,
        refresh: refreshToken,
      );

      // 4. Mapea la data del perfil de usuario que responde tu servidor
      return LoggedUser.fromMap(response.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      final mensajeError =
          e.response?.data['detail'] ?? 'Credenciales incorrectas';
      throw Exception(mensajeError);
    }
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clearSession();
  }

  @override
  Future<LoggedUser?> checkAuthStatus() async {
    final token = await _secureStorage.getAccessToken();
    if (token == null) return null;

    try {
      // 🛠️ USA TU ENDPOINT REAL: Llama a /perfiles-usuario/ para verificar la sesión activa
      final response = await _dioClient.dio.get(
        '/perfiles-usuario/me/',
      ); // o /perfiles-usuario/ según tu vista
      return LoggedUser.fromMap(response.data as Map<String, dynamic>);
    } catch (_) {
      await logout();
      return null;
    }
  }
}
