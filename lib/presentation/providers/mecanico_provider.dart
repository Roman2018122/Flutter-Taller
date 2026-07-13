import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/mecanico.dart';
import '../../domain/repository/mecanico_repository.dart';

class MecanicoProvider extends ChangeNotifier {
  final MecanicoRepository repository;

  MecanicoProvider({required this.repository});

  List<Mecanico> _mecanicos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Mecanico> get mecanicos => List.unmodifiable(_mecanicos);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarMecanicos({String? search}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _mecanicos = await repository.listar(search: search);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los mecánicos.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearMecanico(Mecanico mecanico) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creado = await repository.crear(mecanico);
      _mecanicos.add(creado);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear el mecánico.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarMecanico(int id, Mecanico mecanico) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizado = await repository.editar(id, mecanico);

      final index = _mecanicos.indexWhere((item) => item.id == id);

      if (index != -1) {
        _mecanicos[index] = actualizado;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar el mecánico.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarMecanico(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);
      _mecanicos.removeWhere((item) => item.id == id);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el mecánico.';
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
