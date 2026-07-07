// lib/data/local/secure_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  // Configuración estándar para Android e iOS
  SecureStorage() : _storage = const FlutterSecureStorage();

  static const _keyAccess = 'jwt_access_token';
  static const _keyRefresh = 'jwt_refresh_token';

  // Guardar los tokens cuando el login sea exitoso
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  // Leer el token de acceso para las peticiones a Django
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccess);
  }

  // Leer el token de refresco
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefresh);
  }

  // Borrar todo cuando el usuario cierre sesión
  Future<void> clearSession() async {
    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
  }
}
