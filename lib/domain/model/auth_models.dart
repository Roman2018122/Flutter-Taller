// lib/domain/model/auth_models.dart

class AuthTokens {
  final String access;
  final String refresh;

  const AuthTokens({required this.access, required this.refresh});
}

class LoggedUser {
  final int id;
  final String username;
  final String email;
  final bool isStaff; // true si es Administrador/Mecánico, false si es Cliente
  final String
  rol; // "ADMIN", "MECANICO", "CLIENTE" (Según tus roles de Django)

  const LoggedUser({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.rol,
  });

  // Este constructor tomará los datos del JSON decodificado de tu login de Django
  factory LoggedUser.fromMap(Map<String, dynamic> map) => LoggedUser(
    id: map['user_id'] ?? map['id'] as int,
    username: map['username'] as String,
    email: map['email'] as String,
    isStaff: map['is_staff'] ?? false as bool,
    rol:
        map['rol'] ??
        'CLIENTE' as String, // Si viene vacío, por defecto es cliente
  );
}
