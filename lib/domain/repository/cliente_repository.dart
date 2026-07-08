// lib/domain/repository/cliente_repository.dart

import '../model/cliente_model.dart';

abstract class ClienteRepository {
  Future<List<Cliente>> getClientes();
  Future<Cliente> createCliente(Cliente cliente);
  Future<Cliente> updateCliente(Cliente cliente);
  Future<void> deleteCliente(int id);
}
