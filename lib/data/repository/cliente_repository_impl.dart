import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/cliente.dart';
import '../../domain/repository/cliente_repository.dart';
import '../remote/dto/cliente_dto.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final Dio dio;

  ClienteRepositoryImpl({required this.dio});

  static const String _endpoint = 'clientes/';

  @override
  Future<List<Cliente>> listar({String? search}) async {
    try {
      final response = await dio.get<dynamic>(
        _endpoint,
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );

      final data = response.data;

      if (data is List) {
        return data
            .map(
              (item) =>
                  ClienteDto.fromJson(item as Map<String, dynamic>).toDomain(),
            )
            .toList();
      }

      // Para cuando agregues paginación en Django.
      if (data is Map<String, dynamic> && data['results'] is List) {
        final results = data['results'] as List;

        return results
            .map(
              (item) =>
                  ClienteDto.fromJson(item as Map<String, dynamic>).toDomain(),
            )
            .toList();
      }

      throw const ApiException(
        message: 'La respuesta de clientes no tiene el formato esperado.',
      );
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Cliente> obtener(int id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('$_endpoint$id/');

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor devolvió una respuesta vacía.',
        );
      }

      return ClienteDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Cliente> crear(Cliente cliente) async {
    try {
      final dto = ClienteDto.fromDomain(cliente);

      final response = await dio.post<Map<String, dynamic>>(
        _endpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(message: 'No se recibió el cliente creado.');
      }

      return ClienteDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Cliente> editar(int id, Cliente cliente) async {
    try {
      final dto = ClienteDto.fromDomain(cliente);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_endpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'No se recibió el cliente actualizado.',
        );
      }

      return ClienteDto.fromJson(data).toDomain();
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

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con clientes.',
    );
  }
}
