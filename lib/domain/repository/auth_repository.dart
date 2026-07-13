import '../model/auth_models.dart';

import '../model/register_request.dart';

abstract interface class AuthRepository {
  Future<AuthTokens> login({
    required String username,
    required String password,
  });

  Future<void> register(RegisterRequest request);

  Future<bool> hasSession();

  Future<void> logout();
}
