import '../model/cliente.dart';

abstract interface class ClienteRepository {
  Future<List<Cliente>> listar({String? search});

  Future<Cliente> obtener(int id);

  Future<Cliente> crear(Cliente cliente);

  Future<Cliente> editar(int id, Cliente cliente);

  Future<void> eliminar(int id);
}
