// lib/data/remote/api/dio_client.dart

import 'package:dio/dio.dart';
import '../../../core/config/app_config.dart';
import '../interceptor/auth_interceptor.dart';
import '../../local/secure_storage.dart';

class DioClient {
  final Dio _dio;

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _dio.interceptors.add(AuthInterceptor(SecureStorage()));
  }

  Dio get dio => _dio;
}
