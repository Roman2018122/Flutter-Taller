import '../model/orden_reparacion.dart';

abstract interface class OrdenReparacionRepository {
  Future<List<OrdenReparacion>> listar({String? search, String? estado});

  Future<OrdenReparacion> obtener(int id);

  Future<OrdenReparacion> crear(OrdenReparacion orden);

  Future<OrdenReparacion> editar(int id, OrdenReparacion orden);

  Future<void> eliminar(int id);
}
