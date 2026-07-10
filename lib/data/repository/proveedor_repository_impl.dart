// lib/data/repository/proveedor_repository_impl.dart

import 'package:taller_mecanico_app/domain/model/proveedor_model.dart';
import 'package:taller_mecanico_app/domain/repository/proveedor_repository.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';

class ProveedorRepositoryImpl implements ProveedorRepository {
  final DioClient _dioClient;

  ProveedorRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Proveedor>> getProveedores() async {
    try {
      final response = await _dioClient.dio.get('/proveedores/');
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Proveedor.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al cargar la lista de proveedores: $e');
    }
  }

  @override
  Future<Proveedor> createProveedor(Proveedor proveedor) async {
    try {
      final response = await _dioClient.dio.post('/proveedores/', data: proveedor.toJson());
      return Proveedor.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al dar de alta al proveedor: $e');
    }
  }

  @override
  Future<Proveedor> updateProveedor(Proveedor proveedor) async {
    try {
      final response = await _dioClient.dio.put('/proveedores/${proveedor.id}/', data: proveedor.toJson());
      return Proveedor.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar datos del proveedor: $e');
    }
  }

  @override
  Future<void> deleteProveedor(int id) async {
    try {
      await _dioClient.dio.delete('/proveedores/$id/');
    } catch (e) {
      throw Exception('Error al eliminar al proveedor del sistema: $e');
    }
  }
}