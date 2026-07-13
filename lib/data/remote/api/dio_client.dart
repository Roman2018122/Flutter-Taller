import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/api_exception.dart';
import '../../local/secure_storage.dart';
import '../interceptor/auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient({required SecureStorageService storage})
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(AuthInterceptor(storage: storage));

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: _mapError(error),
            ),
          );
        },
      ),
    );

    // Útil mientras desarrollas. Evita imprimir tokens manualmente.
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
      ),
    );
  }

  static ApiException _mapError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final detail = data['detail'];

      if (detail is String && detail.isNotEmpty) {
        return ApiException(message: detail, statusCode: statusCode);
      }

      return ApiException(
        message: 'Revisa los datos enviados.',
        statusCode: statusCode,
        validationErrors: data,
      );
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const ApiException(
        message:
            'No se pudo conectar con el servidor. Verifica que Django esté encendido.',
      );
    }

    return ApiException(
      message: 'Ocurrió un error al comunicarse con el servidor.',
      statusCode: statusCode,
    );
  }
}
