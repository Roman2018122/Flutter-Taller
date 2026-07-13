import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/detalle_servicio.dart';
import '../../domain/repository/detalle_servicio_repository.dart';

class DetalleServicioProvider extends ChangeNotifier {
  final DetalleServicioRepository repository;

  DetalleServicioProvider({required this.repository});

  List<DetalleServicio> _detalles = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DetalleServicio> get detalles => List.unmodifiable(_detalles);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get totalOrden {
    return _detalles.fold(0, (total, detalle) => total + detalle.subtotal);
  }

  Future<void> cargarPorOrden(int ordenId) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _detalles = await repository.listarPorOrden(ordenId);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los servicios de la orden.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearDetalle(DetalleServicio detalle) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creado = await repository.crear(detalle);

      _detalles.add(creado);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo agregar el servicio a la orden.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarDetalle(int id, DetalleServicio detalle) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizado = await repository.editar(id, detalle);

      final index = _detalles.indexWhere((item) => item.id == id);

      if (index != -1) {
        _detalles[index] = actualizado;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar el servicio de la orden.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarDetalle(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);

      _detalles.removeWhere((item) => item.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el servicio de la orden.';
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
