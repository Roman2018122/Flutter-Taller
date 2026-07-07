// lib/data/remote/interceptor/auth_interceptor.dart

import 'package:dio/dio.dart';
import '../../local/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Buscamos si hay un token de acceso guardado en el teléfono
    final token = await _secureStorage.getAccessToken();

    // 2. Si el token existe, se lo inyectamos automáticamente a la cabecera
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Continuamos con la petición de forma normal
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Aquí atraparemos si Django nos devuelve un 401 (Token Expirado)
    if (err.response?.statusCode == 401) {
      // TODO: Aquí implementaremos el refresco automático del token con SimpleJWT
    }
    return handler.next(err);
  }
}
