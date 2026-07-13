import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/especialidad.dart';
import '../../domain/repository/especialidad_repository.dart';

class EspecialidadProvider extends ChangeNotifier {
  final EspecialidadRepository repository;

  EspecialidadProvider({required this.repository});

  List<Especialidad> _especialidades = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Especialidad> get especialidades => List.unmodifiable(_especialidades);

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> cargarEspecialidades({String? search}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _especialidades = await repository.listar(search: search);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar las especialidades.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearEspecialidad(Especialidad especialidad) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creada = await repository.crear(especialidad);

      _especialidades.add(creada);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear la especialidad.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarEspecialidad(int id, Especialidad especialidad) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizada = await repository.editar(id, especialidad);

      final index = _especialidades.indexWhere((item) => item.id == id);

      if (index != -1) {
        _especialidades[index] = actualizada;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar la especialidad.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarEspecialidad(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);

      _especialidades.removeWhere((item) => item.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar la especialidad.';
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
