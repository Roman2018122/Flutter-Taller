import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/orden_reparacion.dart';
import '../../domain/repository/orden_reparacion_repository.dart';
import '../remote/dto/orden_reparacion_dto.dart';

class OrdenReparacionRepositoryImpl implements OrdenReparacionRepository {
  final Dio dio;

  OrdenReparacionRepositoryImpl({required this.dio});

  // Cambia únicamente esta constante si tu router usa otro prefijo.
  static const String _endpoint = 'ordenes-reparacion/';

  @override
  Future<List<OrdenReparacion>> listar({String? search, String? estado}) async {
    try {
      final response = await dio.get<dynamic>(
        _endpoint,
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (estado != null && estado.isNotEmpty) 'estado': estado,
        },
      );

      final items = _extractList(response.data);

      return items
          .map(
            (item) => OrdenReparacionDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<OrdenReparacion> obtener(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('$_endpoint$id/');

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      return OrdenReparacionDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<OrdenReparacion> crear(OrdenReparacion orden) async {
    try {
      final dto = OrdenReparacionDto.fromDomain(orden);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió la orden creada.',
        );
      }

      return OrdenReparacionDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<OrdenReparacion> editar(int id, OrdenReparacion orden) async {
    try {
      final dto = OrdenReparacionDto.fromDomain(orden);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió la orden actualizada.',
        );
      }

      return OrdenReparacionDto.fromJson(data).toDomain();
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
      message: 'La respuesta de órdenes no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con órdenes.',
    );
  }
}
