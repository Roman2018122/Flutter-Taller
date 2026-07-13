import 'package:dio/dio.dart';

import '../../local/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storage;

  AuthInterceptor({required this.storage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isLoginRequest =
        options.path.endsWith('token/') &&
        !options.path.endsWith('token/refresh/');

    final isRefreshRequest = options.path.endsWith('token/refresh/');

    if (!isLoginRequest && !isRefreshRequest) {
      final token = await storage.getAccessToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }
}
