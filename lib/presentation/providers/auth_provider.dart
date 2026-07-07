// lib/presentation/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../../domain/model/auth_models.dart';
import '../../domain/repository/auth_repository.dart';

enum AuthStatus { checking, authenticated, unauthenticated }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthStatus _status = AuthStatus.checking;
  LoggedUser? _currentUser;
  String? _errorMessage;

  AuthProvider({required AuthRepository authRepository})
    : _authRepository = authRepository {
    // Apenas se enciende la app, verifica si hay una sesión guardada
    checkStatus();
  }

  // ── Getters para que las pantallas lean el estado ────────────────
  AuthStatus get status => _status;
  LoggedUser? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.checking;

  // ── Acción de Login ──────────────────────────────────────────────
  Future<bool> login(String username, String password) async {
    _status = AuthStatus.checking;
    _errorMessage = null;
    notifyListeners(); // Le avisa a la pantalla que ponga un círculo de carga

    try {
      _currentUser = await _authRepository.login(
        username: username,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners(); // Redibuja la app y le da acceso al sistema
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners(); // Muestra el mensaje de error en la pantalla
      return false;
    }
  }

  // ── Verificar Sesión Automática ──────────────────────────────────
  Future<void> checkStatus() async {
    try {
      _currentUser = await _authRepository.checkAuthStatus();
      _status = (_currentUser != null)
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    } catch (_) {
      _status = AuthStatus.unauthenticated;
      _currentUser = null;
    }
    notifyListeners();
  }

  // ── Cerrar Sesión ────────────────────────────────────────────────
  Future<void> logout() async {
    await _authRepository.logout();
    _status = AuthStatus.unauthenticated;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners(); // Saca al usuario instantáneamente a la pantalla de Login
  }
}
