import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/mecanico.dart';
import '../../domain/repository/mecanico_repository.dart';
import '../remote/dto/mecanico_dto.dart';

class MecanicoRepositoryImpl implements MecanicoRepository {
  final Dio dio;

  MecanicoRepositoryImpl({required this.dio});

  static const String _endpoint = 'mecanicos/';

  @override
  Future<List<Mecanico>> listar({String? search}) async {
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
            (item) => MecanicoDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Mecanico> obtener(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('$_endpoint$id/');

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      return MecanicoDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Mecanico> crear(Mecanico mecanico) async {
    try {
      final dto = MecanicoDto.fromDomain(mecanico);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el mecánico creado.',
        );
      }

      return MecanicoDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Mecanico> editar(int id, Mecanico mecanico) async {
    try {
      final dto = MecanicoDto.fromDomain(mecanico);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el mecánico actualizado.',
        );
      }

      return MecanicoDto.fromJson(data).toDomain();
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
      message: 'La respuesta de mecánicos no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con mecánicos.',
    );
  }
}
