// lib/presentation/providers/repuesto_provider.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/repuesto_model.dart';
import 'package:taller_mecanico_app/domain/repository/repuesto_repository.dart';

class RepuestoProvider extends ChangeNotifier {
  final RepuestoRepository _repuestoRepository;

  List<Repuesto> _repuestos = [];
  bool _isLoading = false;
  String? _errorMessage;

  RepuestoProvider({required RepuestoRepository repuestoRepository})
      : _repuestoRepository = repuestoRepository {
    cargarRepuestos();
  }

  // Getters para la UI
  List<Repuesto> get repuestos => _repuestos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🔄 OBTENER INVENTARIO (READ)
  Future<void> cargarRepuestos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _repuestos = await _repuestoRepository.getRepuestos();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ AGREGAR PIEZA (CREATE)
  Future<bool> agregarRepuesto(Repuesto nuevoRepuesto) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final repuestoCreado = await _repuestoRepository.createRepuesto(nuevoRepuesto);
      _repuestos.add(repuestoCreado);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // 📝 MODIFICAR STOCK O DATOS (UPDATE)
  Future<bool> modificarRepuesto(Repuesto repuestoEditado) async {
    if (repuestoEditado.id == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _repuestoRepository.updateRepuesto(repuestoEditado);
      final index = _repuestos.indexWhere((r) => r.id == actualizado.id);
      if (index != -1) {
        _repuestos[index] = actualizado;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }

  // ❌ BAJA DE INVENTARIO (DELETE)
  Future<bool> removerRepuesto(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repuestoRepository.deleteRepuesto(id);
      _repuestos.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
    }
  }
}