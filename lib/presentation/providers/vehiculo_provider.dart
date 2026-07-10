// lib/presentation/providers/vehiculo_provider.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/vehiculo_model.dart';
import 'package:taller_mecanico_app/domain/repository/vehiculo_repository.dart';

class VehiculoProvider extends ChangeNotifier {
  final VehiculoRepository _vehiculoRepository;

  List<Vehiculo> _vehiculos = [];
  bool _isLoading = false;
  String? _errorMessage;

  VehiculoProvider({required VehiculoRepository vehiculoRepository})
      : _vehiculoRepository = vehiculoRepository {
    cargarVehiculos();
  }

  List<Vehiculo> get vehiculos => _vehiculos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarVehiculos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vehiculos = await _vehiculoRepository.getVehiculos();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarVehiculo(Vehiculo nuevoVehiculo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final vehiculoCreado = await _vehiculoRepository.createVehiculo(nuevoVehiculo);
      _vehiculos.add(vehiculoCreado);
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

  Future<bool> modificarVehiculo(Vehiculo vehiculoEditado) async {
    if (vehiculoEditado.id == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _vehiculoRepository.updateVehiculo(vehiculoEditado);
      final index = _vehiculos.indexWhere((v) => v.id == actualizado.id);
      if (index != -1) {
        _vehiculos[index] = actualizado;
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

  Future<bool> removerVehiculo(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _vehiculoRepository.deleteVehiculo(id);
      _vehiculos.removeWhere((v) => v.id == id);
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