import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/especialidad.dart';
import '../../domain/repository/especialidad_repository.dart';
import '../remote/dto/especialidad_dto.dart';

class EspecialidadRepositoryImpl implements EspecialidadRepository {
  final Dio dio;

  EspecialidadRepositoryImpl({required this.dio});

  // Debe coincidir con tu router de Django.
  static const String _endpoint = 'especialidades/';

  @override
  Future<List<Especialidad>> listar({String? search}) async {
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
            (item) => EspecialidadDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Especialidad> obtener(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('$_endpoint$id/');

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      return EspecialidadDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Especialidad> crear(Especialidad especialidad) async {
    try {
      final dto = EspecialidadDto.fromDomain(especialidad);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió la especialidad creada.',
        );
      }

      return EspecialidadDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Especialidad> editar(int id, Especialidad especialidad) async {
    try {
      final dto = EspecialidadDto.fromDomain(especialidad);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió la especialidad actualizada.',
        );
      }

      return EspecialidadDto.fromJson(data).toDomain();
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
      message: 'La respuesta de especialidades no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con especialidades.',
    );
  }
}
