import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/model/vehiculo.dart';
import '../../domain/repository/vehiculo_repository.dart';

class VehiculoProvider extends ChangeNotifier {
  final VehiculoRepository repository;

  VehiculoProvider({required this.repository});

  List<Vehiculo> _vehiculos = [];
  List<ModeloVehiculoOption> _modelos = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<Vehiculo> get vehiculos => List.unmodifiable(_vehiculos);

  List<ModeloVehiculoOption> get modelos => List.unmodifiable(_modelos);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarVehiculos({String? search}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _vehiculos = await repository.listar(search: search);
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los vehículos.';
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cargarModelos() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      _modelos = await repository.listarModelos();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudieron cargar los modelos de vehículos.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> crearVehiculo(Vehiculo vehiculo) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final creado = await repository.crear(vehiculo);
      _vehiculos.add(creado);
      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo crear el vehículo.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> editarVehiculo(int id, Vehiculo vehiculo) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final actualizado = await repository.editar(id, vehiculo);

      final index = _vehiculos.indexWhere((item) => item.id == id);

      if (index != -1) {
        _vehiculos[index] = actualizado;
      }

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo editar el vehículo.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> eliminarVehiculo(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.eliminar(id);

      _vehiculos.removeWhere((vehiculo) => vehiculo.id == id);

      notifyListeners();
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo eliminar el vehículo.';
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
