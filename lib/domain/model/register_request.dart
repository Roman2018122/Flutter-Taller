class RegisterRequest {
  final String username;
  final String password;
  final String passwordConfirmacion;

  final String nombre;
  final String telefono;
  final String correo;
  final String direccion;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.passwordConfirmacion,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "password_confirmacion": passwordConfirmacion,
      "nombre": nombre,
      "telefono": telefono,
      "correo": correo,
      "direccion": direccion,
    };
  }
}
