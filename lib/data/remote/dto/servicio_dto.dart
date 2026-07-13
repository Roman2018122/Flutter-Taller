import '../../../domain/model/servicio.dart';

class ServicioDto {
  final int? id;
  final String nombre;
  final String? descripcion;
  final double precioReferencial;

  const ServicioDto({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.precioReferencial,
  });

  factory ServicioDto.fromJson(Map<String, dynamic> json) {
    return ServicioDto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String?,
      precioReferencial: _parseDouble(json['precio_referencial']),
    );
  }

  factory ServicioDto.fromDomain(Servicio servicio) {
    return ServicioDto(
      id: servicio.id,
      nombre: servicio.nombre,
      descripcion: servicio.descripcion,
      precioReferencial: servicio.precioReferencial,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion?.trim().isEmpty == true
          ? null
          : descripcion?.trim(),
      'precio_referencial': precioReferencial.toStringAsFixed(2),
    };
  }

  Servicio toDomain() {
    return Servicio(
      id: id,
      nombre: nombre,
      descripcion: descripcion,
      precioReferencial: precioReferencial,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
