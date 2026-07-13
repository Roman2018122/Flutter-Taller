import '../model/servicio.dart';

abstract interface class ServicioRepository {
  Future<List<Servicio>> listar({String? search});

  Future<Servicio> obtener(int id);

  Future<Servicio> crear(Servicio servicio);

  Future<Servicio> editar(int id, Servicio servicio);

  Future<void> eliminar(int id);
}
