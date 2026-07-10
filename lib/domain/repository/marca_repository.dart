// lib/domain/repository/marca_repository.dart

import '../model/marca_model.dart';

abstract class MarcaRepository {
  Future<List<Marca>> getMarcas();
  Future<Marca> createMarca(Marca marca);
  Future<Marca> updateMarca(Marca marca);
  Future<void> deleteMarca(int id);
}