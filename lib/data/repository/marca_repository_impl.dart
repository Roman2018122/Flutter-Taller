// lib/data/repository/marca_repository_impl.dart

import 'package:taller_mecanico_app/domain/model/marca_model.dart';
import 'package:taller_mecanico_app/domain/repository/marca_repository.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';

class MarcaRepositoryImpl implements MarcaRepository {
  final DioClient _dioClient;

  MarcaRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<Marca>> getMarcas() async {
    try {
      final response = await _dioClient.dio.get('/marcas/');
      
      if (response.data is List) {
        return (response.data as List)
            .map((item) => Marca.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener las marcas: $e');
    }
  }

  @override
  Future<Marca> createMarca(Marca marca) async {
    try {
      final response = await _dioClient.dio.post('/marcas/', data: marca.toMap());
      return Marca.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al registrar la marca: $e');
    }
  }

  @override
  Future<Marca> updateMarca(Marca marca) async {
    try {
      final response = await _dioClient.dio.put('/marcas/${marca.id}/', data: marca.toMap());
      return Marca.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar la marca: $e');
    }
  }

  @override
  Future<void> deleteMarca(int id) async {
    try {
      await _dioClient.dio.delete('/marcas/$id/');
    } catch (e) {
      throw Exception('Error al eliminar la marca: $e');
    }
  }
}