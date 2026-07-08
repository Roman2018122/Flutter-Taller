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
  final String rol; // "ADMIN", "MECANICO", "CLIENTE"

  const LoggedUser({
    required this.id,
    required this.username,
    required this.email,
    required this.isStaff,
    required this.rol,
  });

  // 🛠️ CONSTRUCTOR CORREGIDO Y ULTRA SEGURO:
  factory LoggedUser.fromMap(Map<String, dynamic> map) {
    // Extraemos el rol de forma segura mapeando 'role' (Django) o 'rol' (Flutter)
    final stringRol = (map['role'] ?? map['rol'] ?? 'CLIENTE')
        .toString()
        .toUpperCase();

    return LoggedUser(
      // Nos aseguramos de que el ID sea entero pase lo que pase
      id: map['id'] is int
          ? map['id'] as int
          : int.parse((map['id'] ?? 0).toString()),
      username: (map['username'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      // Si el rol es admin o mecanico, asumimos isStaff como true de forma automatizada
      isStaff:
          map['is_staff'] ?? (stringRol == 'ADMIN' || stringRol == 'MECANICO'),
      rol: stringRol,
    );
  }
}
