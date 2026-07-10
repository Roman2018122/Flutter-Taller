// lib/presentation/providers/marca_provider.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/marca_model.dart';
import 'package:taller_mecanico_app/domain/repository/marca_repository.dart';

class MarcaProvider extends ChangeNotifier {
  final MarcaRepository _marcaRepository;

  List<Marca> _marcas = [];
  bool _isLoading = false;
  String? _errorMessage;

  MarcaProvider({required MarcaRepository marcaRepository})
      : _marcaRepository = marcaRepository {
    cargarMarcas(); // Carga las marcas automáticamente al inicializar el módulo
  }

  // Getters para la interfaz gráfica
  List<Marca> get marcas => _marcas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🔄 OBTENER MARCAS (READ)
  Future<void> cargarMarcas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _marcas = await _marcaRepository.getMarcas();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ CREAR MARCA (CREATE)
  Future<bool> agregarMarca(Marca nuevaMarca) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final marcaCreada = await _marcaRepository.createMarca(nuevaMarca);
      _marcas.add(marcaCreada); // Actualización local optimizada
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

  // 📝 ACTUALIZAR MARCA (UPDATE)
  Future<bool> modificarMarca(Marca marcaEditada) async {
    if (marcaEditada.id == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _marcaRepository.updateMarca(marcaEditada);
      final index = _marcas.indexWhere((m) => m.id == actualizado.id);
      if (index != -1) {
        _marcas[index] = actualizado;
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

  // ❌ ELIMINAR MARCA (DELETE)
  Future<bool> removerMarca(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _marcaRepository.deleteMarca(id);
      _marcas.removeWhere((m) => m.id == id); // Remueve localmente
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