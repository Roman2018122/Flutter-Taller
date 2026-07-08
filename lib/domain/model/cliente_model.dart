// lib/domain/model/cliente_model.dart

class Cliente {
  final int? id; // Opcional porque al crear uno nuevo, Django genera el ID
  final String nombres;
  final String apellidos;
  final String cedulaIdentidad;
  final String? telefono;
  final String? email;
  final String? direccion;

  const Cliente({
    this.id,
    required this.nombres,
    required this.apellidos,
    required this.cedulaIdentidad,
    this.telefono,
    this.email,
    this.direccion,
  });

  // Convierte un JSON/Mapa de Django a un Objeto de Flutter (Seguro contra nulos)
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'] as int?,
      nombres: (map['nombres'] ?? '').toString(),
      apellidos: (map['apellidos'] ?? '').toString(),
      cedulaIdentidad: (map['cedula_identidad'] ?? '').toString(),
      telefono: map['telefono']?.toString(),
      email: map['email']?.toString(),
      direccion: map['direccion']?.toString(),
    );
  }

  // Convierte el objeto de Flutter a un Mapa listo para enviarse por POST/PUT a Django
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'cedula_identidad': cedulaIdentidad,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
    };
  }

  // Helper para mostrar el nombre completo en las listas del taller
  String get nombreCompleto => '$nombres $apellidos';
}
