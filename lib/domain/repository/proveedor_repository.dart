// lib/domain/repository/proveedor_repository.dart

import '../model/proveedor_model.dart';

abstract class ProveedorRepository {
  Future<List<Proveedor>> getProveedores();
  Future<Proveedor> createProveedor(Proveedor proveedor);
  Future<Proveedor> updateProveedor(Proveedor proveedor);
  Future<void> deleteProveedor(int id);
}