import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/orden_reparacion.dart';
import '../../domain/repository/orden_reparacion_repository.dart';

class OrdenReparacionProvider extends ChangeNotifier {
  final OrdenReparacionRepository repository;

  OrdenReparacionProvider({required this.repository});

  List<OrdenReparacion> _ordenes = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<OrdenReparacion> get ordenes => List.unmodifiable(_ordenes);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarOrdenes({String? search, String? estado}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _ordenes = await repository.listar(search: search, estado: estado);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las órdenes.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearOrden(OrdenReparacion orden) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creada = await repository.crear(orden);
      _ordenes.insert(0, creada);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear la orden.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarOrden(int id, OrdenReparacion orden) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizada = await repository.editar(id, orden);

      final index = _ordenes.indexWhere((item) => item.id == id);

      if (index != -1) {
        _ordenes[index] = actualizada;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar la orden.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarOrden(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);

      _ordenes.removeWhere((orden) => orden.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar la orden.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  String _formatError(ApiException error) {
    final errors = error.validationErrors;

    if (errors == null || errors.isEmpty) {
      return error.message;
    }

    final messages = <String>[];

    errors.forEach((field, value) {
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
