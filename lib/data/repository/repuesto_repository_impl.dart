// lib/data/repository/repuesto_repository_impl.dart

import 'package:dio/dio.dart';
import 'package:taller_mecanico_app/domain/model/repuesto_model.dart';
import 'package:taller_mecanico_app/domain/repository/repuesto_repository.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';

class RepuestoRepositoryImpl implements RepuestoRepository {
  final DioClient _dioClient;

  RepuestoRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Repuesto>> getRepuestos() async {
    try {
      final response = await _dioClient.dio.get('/repuestos/');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Repuesto.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar el inventario de repuestos: $e');
    }
  }

  @override
  Future<Repuesto> createRepuesto(Repuesto repuesto) async {
    try {
      final response = await _dioClient.dio.post('/repuestos/', data: repuesto.toMap());
      return Repuesto.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al registrar la pieza en inventario: $e');
    }
  }

  @override
  Future<Repuesto> updateRepuesto(Repuesto repuesto) async {
    try {
      final response = await _dioClient.dio.put('/repuestos/${repuesto.id}/', data: repuesto.toMap());
      return Repuesto.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar el repuesto: $e');
    }
  }

  @override
  Future<void> deleteRepuesto(int id) async {
    try {
      await _dioClient.dio.delete('/repuestos/$id/');
    } catch (e) {
      throw Exception('Error al eliminar la pieza del sistema: $e');
    }
  }
}