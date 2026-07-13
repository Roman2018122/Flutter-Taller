import 'package:flutter/foundation.dart';

import '../../core/error/api_exception.dart';
import '../../domain/repository/auth_repository.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository repository;

  AuthProvider({required this.repository});

  AuthStatus _status = AuthStatus.checking;
  bool _isLoading = false;
  String? _errorMessage;

  AuthStatus get status => _status;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    final hasSession = await repository.hasSession();

    _status = hasSession
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    notifyListeners();
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await repository.login(username: username, password: password);

      _status = AuthStatus.authenticated;
      return true;
    } on ApiException catch (error) {
      _errorMessage = _formatError(error);
      _status = AuthStatus.unauthenticated;
      return false;
    } catch (_) {
      _errorMessage = 'Ocurrió un error inesperado.';
      _status = AuthStatus.unauthenticated;
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await repository.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
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
