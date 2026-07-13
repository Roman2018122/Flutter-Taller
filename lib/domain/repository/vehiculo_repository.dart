import '../model/vehiculo.dart';

abstract interface class VehiculoRepository {
  Future<List<Vehiculo>> listar({String? search});

  Future<List<ModeloVehiculoOption>> listarModelos();

  Future<Vehiculo> crear(Vehiculo vehiculo);

  Future<Vehiculo> editar(int id, Vehiculo vehiculo);

  Future<void> eliminar(int id);
}
