// lib/domain/model/marca_model.dart

class Marca {
  final int? id; // Opcional porque Django lo autogenera al crear
  final String nombre;
  final String? descripcion;

  const Marca({
    this.id,
    required this.nombre,
    this.descripcion,
  });

  // Convierte un JSON/Mapa de Django a un Objeto de Flutter
  factory Marca.fromMap(Map<String, dynamic> map) {
    return Marca(
      id: map['id'] as int?,
      nombre: (map['nombre'] ?? '').toString(),
      descripcion: map['descripcion']?.toString(),
    );
  }

  // Convierte el objeto de Flutter a un Mapa listo para Django (POST/PUT)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }
}