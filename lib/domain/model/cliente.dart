class Cliente {
  final int? id;
  final String nombre;
  final String telefono;
  final String correo;
  final String direccion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Cliente({
    this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.direccion,
    this.createdAt,
    this.updatedAt,
  });
}
