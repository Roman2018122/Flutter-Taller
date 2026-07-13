import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/servicio.dart';
import '../../domain/repository/servicio_repository.dart';

class ServicioProvider extends ChangeNotifier {
  final ServicioRepository repository;

  ServicioProvider({required this.repository});

  List<Servicio> _servicios = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Servicio> get servicios => List.unmodifiable(_servicios);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarServicios({String? search}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _servicios = await repository.listar(search: search);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los servicios.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearServicio(Servicio servicio) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creado = await repository.crear(servicio);
      _servicios.add(creado);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear el servicio.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarServicio(int id, Servicio servicio) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizado = await repository.editar(id, servicio);

      final index = _servicios.indexWhere((item) => item.id == id);

      if (index != -1) {
        _servicios[index] = actualizado;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar el servicio.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarServicio(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);

      _servicios.removeWhere((servicio) => servicio.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el servicio.';
      return false;
    } finally {
      _setLoading(false);
    }
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
