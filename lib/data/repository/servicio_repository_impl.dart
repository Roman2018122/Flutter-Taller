import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/servicio.dart';
import '../../domain/repository/servicio_repository.dart';
import '../remote/dto/servicio_dto.dart';

class ServicioRepositoryImpl implements ServicioRepository {
  final Dio dio;

  ServicioRepositoryImpl({required this.dio});

  static const String _endpoint = 'servicios/';

  @override
  Future<List<Servicio>> listar({String? search}) async {
    try {
      final response = await dio.get<dynamic>(
        _endpoint,
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );

      final items = _extractList(response.data);

      return items
          .map(
            (item) => ServicioDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Servicio> obtener(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('$_endpoint$id/');

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      return ServicioDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Servicio> crear(Servicio servicio) async {
    try {
      final dto = ServicioDto.fromDomain(servicio);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el servicio creado.',
        );
      }

      return ServicioDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Servicio> editar(int id, Servicio servicio) async {
    try {
      final dto = ServicioDto.fromDomain(servicio);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el servicio actualizado.',
        );
      }

      return ServicioDto.fromJson(data).toDomain();
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
      message: 'La respuesta de servicios no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con servicios.',
    );
  }
}
