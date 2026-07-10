// lib/domain/repository/vehiculo_repository.dart

import '../model/vehiculo_model.dart';

abstract class VehiculoRepository {
  Future<List<Vehiculo>> getVehiculos();
  Future<Vehiculo> createVehiculo(Vehiculo vehiculo);
  Future<Vehiculo> updateVehiculo(Vehiculo vehiculo);
  Future<void> deleteVehiculo(int id);
}