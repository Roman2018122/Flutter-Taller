// lib/presentation/providers/proveedor_provider.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/proveedor_model.dart';
import 'package:taller_mecanico_app/domain/repository/proveedor_repository.dart';

class ProveedorProvider extends ChangeNotifier {
  final ProveedorRepository _proveedorRepository;

  List<Proveedor> _proveedores = [];
  bool _isLoading = false;
  String? _errorMessage;

  ProveedorProvider({required ProveedorRepository proveedorRepository})
      : _proveedorRepository = proveedorRepository {
    cargarProveedores();
  }

  List<Proveedor> get proveedores => _proveedores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarProveedores() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _proveedores = await _proveedorRepository.getProveedores();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarProveedor(Proveedor nuevoProveedor) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final creado = await _proveedorRepository.createProveedor(nuevoProveedor);
      _proveedores.add(creado);
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

  Future<bool> modificarProveedor(Proveedor proveedorEditado) async {
    if (proveedorEditado.id == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _proveedorRepository.updateProveedor(proveedorEditado);
      final index = _proveedores.indexWhere((p) => p.id == actualizado.id);
      if (index != -1) {
        _proveedores[index] = actualizado;
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

  Future<bool> removerProveedor(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _proveedorRepository.deleteProveedor(id);
      _proveedores.removeWhere((p) => p.id == id);
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