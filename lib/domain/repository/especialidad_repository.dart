import '../model/especialidad.dart';

abstract interface class EspecialidadRepository {
  Future<List<Especialidad>> listar({String? search});

  Future<Especialidad> obtener(int id);

  Future<Especialidad> crear(Especialidad especialidad);

  Future<Especialidad> editar(int id, Especialidad especialidad);

  Future<void> eliminar(int id);
}
