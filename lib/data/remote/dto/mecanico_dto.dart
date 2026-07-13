import '../../../domain/model/mecanico.dart';

class MecanicoDto {
  final int? id;
  final String nombre;
  final String? telefono;
  final String estado;
  final List<int> especialidades;

  const MecanicoDto({
    this.id,
    required this.nombre,
    this.telefono,
    required this.estado,
    required this.especialidades,
  });

  factory MecanicoDto.fromJson(Map<String, dynamic> json) {
    final especialidadesJson = json['especialidades'] as List<dynamic>? ?? [];

    return MecanicoDto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String? ?? '',
      telefono: json['telefono'] as String?,
      estado: json['estado'] as String? ?? 'activo',
      especialidades: especialidadesJson.map((item) => item as int).toList(),
    );
  }

  factory MecanicoDto.fromDomain(Mecanico mecanico) {
    return MecanicoDto(
      id: mecanico.id,
      nombre: mecanico.nombre,
      telefono: mecanico.telefono,
      estado: mecanico.estado,
      especialidades: mecanico.especialidadesIds,
    );
  }

  Map<String, dynamic> toJson() {
    final telefonoLimpio = telefono?.trim();

    return {
      'nombre': nombre.trim(),
      'telefono': telefonoLimpio == null || telefonoLimpio.isEmpty
          ? null
          : telefonoLimpio,
      'estado': estado,
      'especialidades': especialidades,
    };
  }

  Mecanico toDomain() {
    return Mecanico(
      id: id,
      nombre: nombre,
      telefono: telefono,
      estado: estado,
      especialidadesIds: especialidades,
    );
  }
}
