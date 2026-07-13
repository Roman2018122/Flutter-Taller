import '../model/detalle_servicio.dart';

abstract interface class DetalleServicioRepository {
  Future<List<DetalleServicio>> listarPorOrden(int ordenId);

  Future<DetalleServicio> crear(DetalleServicio detalle);

  Future<DetalleServicio> editar(int id, DetalleServicio detalle);

  Future<void> eliminar(int id);
}
