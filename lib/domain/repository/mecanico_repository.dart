import '../model/mecanico.dart';

abstract interface class MecanicoRepository {
  Future<List<Mecanico>> listar({String? search});

  Future<Mecanico> obtener(int id);

  Future<Mecanico> crear(Mecanico mecanico);

  Future<Mecanico> editar(int id, Mecanico mecanico);

  Future<void> eliminar(int id);
}
