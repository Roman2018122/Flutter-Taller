// lib/presentation/providers/cliente_provider.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/cliente_model.dart';
import 'package:taller_mecanico_app/domain/repository/cliente_repository.dart';

class ClienteProvider extends ChangeNotifier {
  final ClienteRepository _clienteRepository;

  List<Cliente> _clientes = [];
  bool _isLoading = false;
  String? _errorMessage;

  ClienteProvider({required ClienteRepository clienteRepository})
    : _clienteRepository = clienteRepository {
    cargarClientes(); // Carga la lista automáticamente al inicializar el módulo
  }

  // Getters para la UI
  List<Cliente> get clientes => _clientes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 🔄 OBTENER CLIENTES (READ)
  Future<void> cargarClientes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _clientes = await _clienteRepository.getClientes();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ➕ CREAR CLIENTE (CREATE)
  Future<bool> agregarCliente(Cliente nuevoCliente) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final clienteCreado = await _clienteRepository.createCliente(
        nuevoCliente,
      );
      _clientes.add(
        clienteCreado,
      ); // Lo añadimos localmente para no re-descargar toda la lista
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

  // 📝 ACTUALIZAR CLIENTE (UPDATE)
  Future<bool> modificarCliente(Cliente clienteEditado) async {
    if (clienteEditado.id == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final actualizado = await _clienteRepository.updateCliente(
        clienteEditado,
      );
      // Reemplazamos el viejo por el nuevo en la lista local
      final index = _clientes.indexWhere((c) => c.id == actualizado.id);
      if (index != null && index >= 0) {
        _clientes[index] = actualizado;
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

  // ELIMINAR CLIENTE (DELETE)
  Future<bool> removerCliente(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _clienteRepository.deleteCliente(id);
      _clientes.removeWhere((c) => c.id == id); // Lo borramos de la lista local
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
