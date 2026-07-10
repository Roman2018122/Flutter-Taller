// lib/data/repository/vehiculo_repository_impl.dart

import 'package:taller_mecanico_app/domain/model/vehiculo_model.dart';
import 'package:taller_mecanico_app/domain/repository/vehiculo_repository.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';

class VehiculoRepositoryImpl implements VehiculoRepository {
  final DioClient _dioClient;

  VehiculoRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Vehiculo>> getVehiculos() async {
    try {
      final response = await _dioClient.dio.get('/vehiculos/');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Vehiculo.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener los vehículos del taller: $e');
    }
  }

  @override
  Future<Vehiculo> createVehiculo(Vehiculo vehiculo) async {
    try {
      final response = await _dioClient.dio.post('/vehiculos/', data: vehiculo.toJson());
      return Vehiculo.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al registrar el vehículo: $e');
    }
  }

  @override
  Future<Vehiculo> updateVehiculo(Vehiculo vehiculo) async {
    try {
      final response = await _dioClient.dio.put('/vehiculos/${vehiculo.id}/', data: vehiculo.toJson());
      return Vehiculo.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar datos del vehículo: $e');
    }
  }

  @override
  Future<void> deleteVehiculo(int id) async {
    try {
      await _dioClient.dio.delete('/vehiculos/$id/');
    } catch (e) {
      throw Exception('Error al eliminar el vehículo: $e');
    }
  }
}