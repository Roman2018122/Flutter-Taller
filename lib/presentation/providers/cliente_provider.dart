import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/cliente.dart';
import '../../domain/repository/cliente_repository.dart';

class ClienteProvider extends ChangeNotifier {
  final ClienteRepository repository;

  ClienteProvider({required this.repository});

  List<Cliente> _clientes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Cliente> get clientes => List.unmodifiable(_clientes);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarClientes({String? search}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _clientes = await repository.listar(search: search);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'Ocurrió un error inesperado.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearCliente(Cliente cliente) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final nuevoCliente = await repository.crear(cliente);
      _clientes.add(nuevoCliente);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear el cliente.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarCliente(int id, Cliente cliente) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizado = await repository.editar(id, cliente);

      final index = _clientes.indexWhere((item) => item.id == id);

      if (index != -1) {
        _clientes[index] = actualizado;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar el cliente.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarCliente(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);
      _clientes.removeWhere((cliente) => cliente.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el cliente.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _formatError(ApiException error) {
    final validationErrors = error.validationErrors;

    if (validationErrors == null || validationErrors.isEmpty) {
      return error.message;
    }

    final messages = <String>[];

    validationErrors.forEach((field, value) {
      if (value is List) {
        messages.add('$field: ${value.join(', ')}');
      } else {
        messages.add('$field: $value');
      }
    });

    return messages.join('\n');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
