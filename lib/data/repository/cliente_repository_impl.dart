// lib/data/repository/cliente_repository_impl.dart

import '../../../domain/model/cliente_model.dart';
import '../../../domain/repository/cliente_repository.dart';

import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final DioClient _dioClient;

  ClienteRepositoryImpl({required DioClient dioClient})
    : _dioClient = dioClient;

  @override
  Future<List<Cliente>> getClientes() async {
    try {
      final response = await _dioClient.dio.get('/clientes/');

      if (response.data is List) {
        return (response.data as List)
            .map((item) => Cliente.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Error al obtener la lista de clientes: $e');
    }
  }

  @override
  Future<Cliente> createCliente(Cliente cliente) async {
    try {
      final response = await _dioClient.dio.post(
        '/clientes/',
        data: cliente.toMap(),
      );
      return Cliente.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al registrar el cliente: $e');
    }
  }

  @override
  Future<Cliente> updateCliente(Cliente cliente) async {
    try {
      final response = await _dioClient.dio.put(
        '/clientes/${cliente.id}/',
        data: cliente.toMap(),
      );
      return Cliente.fromMap(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error al actualizar el cliente: $e');
    }
  }

  @override
  Future<void> deleteCliente(int id) async {
    try {
      await _dioClient.dio.delete('/clientes/$id/');
    } catch (e) {
      throw Exception('Error al eliminar el cliente: $e');
    }
  }
}
