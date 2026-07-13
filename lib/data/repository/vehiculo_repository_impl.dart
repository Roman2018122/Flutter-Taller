import 'package:dio/dio.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/vehiculo.dart';
import '../../domain/repository/vehiculo_repository.dart';
import '../remote/dto/vehiculo_dto.dart';

class VehiculoRepositoryImpl implements VehiculoRepository {
  final Dio dio;

  VehiculoRepositoryImpl({required this.dio});

  // Ajusta estas rutas si tus prefijos del router son diferentes.
  static const String _vehiculosEndpoint = 'vehiculos/';
  static const String _modelosEndpoint = 'modelos-vehiculo/';

  @override
  Future<List<Vehiculo>> listar({String? search}) async {
    try {
      final response = await dio.get<dynamic>(
        _vehiculosEndpoint,
        queryParameters: {
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );

      return _parseVehiculos(response.data);
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<List<ModeloVehiculoOption>> listarModelos() async {
    try {
      final response = await dio.get<dynamic>(_modelosEndpoint);

      final items = _extractList(response.data);

      return items
          .map(
            (item) => ModeloVehiculoOptionDto.fromJson(
              Map<String, dynamic>.from(item as Map),
            ).toDomain(),
          )
          .toList();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Vehiculo> crear(Vehiculo vehiculo) async {
    try {
      final dto = VehiculoDto.fromDomain(vehiculo);

      final response = await dio.post<Map<String, dynamic>>(
        _vehiculosEndpoint,
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el vehículo creado.',
        );
      }

      return VehiculoDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<Vehiculo> editar(int id, Vehiculo vehiculo) async {
    try {
      final dto = VehiculoDto.fromDomain(vehiculo);

      final response = await dio.patch<Map<String, dynamic>>(
        '$_vehiculosEndpoint$id/',
        data: dto.toJson(),
      );

      final data = response.data;

      if (data == null) {
        throw const ApiException(
          message: 'El servidor no devolvió el vehículo actualizado.',
        );
      }

      return VehiculoDto.fromJson(data).toDomain();
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  @override
  Future<void> eliminar(int id) async {
    try {
      await dio.delete<void>('$_vehiculosEndpoint$id/');
    } on DioException catch (error) {
      throw _mapDioError(error);
    }
  }

  List<Vehiculo> _parseVehiculos(dynamic data) {
    final items = _extractList(data);

    return items
        .map(
          (item) => VehiculoDto.fromJson(
            Map<String, dynamic>.from(item as Map),
          ).toDomain(),
        )
        .toList();
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) {
      return data;
    }

    if (data is Map<String, dynamic> && data['results'] is List) {
      return data['results'] as List<dynamic>;
    }

    throw const ApiException(
      message: 'La respuesta del servidor no tiene el formato esperado.',
    );
  }

  ApiException _mapDioError(DioException error) {
    final mappedError = error.error;

    if (mappedError is ApiException) {
      return mappedError;
    }

    return const ApiException(
      message: 'No se pudo completar la operación con vehículos.',
    );
  }
}
