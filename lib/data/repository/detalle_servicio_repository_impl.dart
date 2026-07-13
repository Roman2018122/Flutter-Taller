import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/detalle_servicio.dart';
import '../../domain/repository/detalle_servicio_repository.dart';
import '../remote/dto/detalle_servicio_dto.dart';

class DetalleServicioRepositoryImpl implements DetalleServicioRepository {
  final Dio dio;

  DetalleServicioRepositoryImpl({required this.dio});

  static const String _endpoint = 'detalles-servicio/';

  @override
  Future<List<DetalleServicio>> listarPorOrden(int ordenId) async {
    try {
      final response = await dio.get<dynamic>(
        _endpoint,
        queryParameters: {'orden': ordenId},
      );

      final items = _extractList(response.data);

      return items
          .map(
            (item) => DetalleServicioDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<DetalleServicio> crear(DetalleServicio detalle) async {
    try {
      final dto = DetalleServicioDto.fromDomain(detalle);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el detalle creado.',
        );
      }

      return DetalleServicioDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<DetalleServicio> editar(int id, DetalleServicio detalle) async {
    try {
      final dto = DetalleServicioDto.fromDomain(detalle);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el detalle actualizado.',
        );
      }

      return DetalleServicioDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<void> eliminar(int id) async {
    try {
      await dio.delete<void>('$_endpoint$id/');
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic> && data['results'] is List) {
      return data['results'] as List<dynamic>;
    }

    throw const ApiException(
      message: 'La respuesta de detalles no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message:
          'No se pudo completar la operación con los servicios de la orden.',
    );
  }
}
