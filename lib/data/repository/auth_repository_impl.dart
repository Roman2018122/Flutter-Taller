import 'package:dio/dio.dart';

import '../../core/config/app_config.dart';
import '../../core/error/api_exception.dart';
import '../../domain/model/auth_models.dart';
import '../../domain/repository/auth_repository.dart';
import '../local/secure_storage.dart';
import '../remote/dto/auth_dto.dart';

import '../../domain/model/register_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final SecureStorageService storage;

  AuthRepositoryImpl({required this.dio, required this.storage});

  @override
  Future<void> register(RegisterRequest request) async {
    try {
      await dio.post<Map<String, dynamic>>('registro/', data: request.toJson());
    } on DioException catch (error) {
      final mappedError = error.error;

      if (mappedError is ApiException) {
        throw mappedError;
      }

      throw const ApiException(message: 'No se pudo crear la cuenta.');
    }
  }

  @override
  Future<AuthTokens> login({
    required String username,
    required String password,
  }) async {
    try {
      final request = LoginRequestDto(
        username: username.trim(),
        password: password,
      );

      final response = await dio.post<Map<String, dynamic>>(
        AppConfig.tokenEndpoint,
        data: request.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      final tokensDto = AuthTokensDto.fromJson(data);

      await storage.saveTokens(
        accessToken: tokensDto.access,
        refreshToken: tokensDto.refresh,
      );

      return tokensDto.toDomain();
    } on DioException catch (error) {
      final mappedError = error.error;

      if (mappedError is ApiException) {
        throw mappedError;
      }

      throw const ApiException(message: 'No se pudo iniciar sesión.');
    } on FormatException catch (error) {
      throw ApiException(message: error.message);
    }
  }

  @override
  Future<bool> hasSession() {
    return storage.hasSession();
  }

  @override
  Future<void> logout() {
    return storage.clearTokens();
  }
}
