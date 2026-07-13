import '../../../domain/model/especialidad.dart';

class EspecialidadDto {
  final int? id;
  final String nombreEspecialidad;
  final String? descripcion;
  final bool estaActiva;

  const EspecialidadDto({
    this.id,
    required this.nombreEspecialidad,
    this.descripcion,
    required this.estaActiva,
  });

  factory EspecialidadDto.fromJson(Map<String, dynamic> json) {
    return EspecialidadDto(
      id: json['id'] as int?,
      nombreEspecialidad: json['nombre_especialidad'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      estaActiva: json['esta_activa'] as bool? ?? true,
    );
  }

  factory EspecialidadDto.fromDomain(Especialidad especialidad) {
    return EspecialidadDto(
      id: especialidad.id,
      nombreEspecialidad: especialidad.nombre,
      descripcion: especialidad.descripcion,
      estaActiva: especialidad.estaActiva,
    );
  }

  Map<String, dynamic> toJson() {
    final descripcionLimpia = descripcion?.trim();

    return {
      'nombre_especialidad': nombreEspecialidad.trim(),
      'descripcion': descripcionLimpia == null || descripcionLimpia.isEmpty
          ? null
          : descripcionLimpia,
      'esta_activa': estaActiva,
    };
  }

  Especialidad toDomain() {
    return Especialidad(
      id: id,
      nombre: nombreEspecialidad,
      descripcion: descripcion,
      estaActiva: estaActiva,
    );
  }
}
