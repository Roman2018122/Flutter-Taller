import '../model/auth_models.dart';

abstract interface class AuthRepository {
  Future<AuthTokens> login({
    required String username,
    required String password,
  });

  Future<bool> hasSession();

  Future<void> logout();
}
