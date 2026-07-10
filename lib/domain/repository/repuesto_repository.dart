// lib/domain/repository/repuesto_repository.dart

import '../model/repuesto_model.dart';

abstract class RepuestoRepository {
  Future<List<Repuesto>> getRepuestos();
  Future<Repuesto> createRepuesto(Repuesto repuesto);
  Future<Repuesto> updateRepuesto(Repuesto repuesto);
  Future<void> deleteRepuesto(int id);
}