// lib/domain/repository/auth_repository.dart

import '../model/auth_models.dart';

abstract class AuthRepository {
  // Define que para loguearse se necesitan un usuario y contraseña,
  // y que Django nos devolverá los datos del usuario logueado.
  Future<LoggedUser> login({
    required String username,
    required String password,
  });

  // Define la función para cerrar sesión en el dispositivo
  Future<void> logout();

  // Comprueba si ya hay una sesión activa guardada al abrir la app
  Future<LoggedUser?> checkAuthStatus();
}
