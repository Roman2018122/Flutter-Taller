import '../../../domain/model/orden_reparacion.dart';

class OrdenReparacionDto {
  final int? id;
  final int vehiculo;
  final String vehiculoPlaca;
  final DateTime? fechaIngreso;
  final DateTime? fechaSalida;
  final String estado;
  final String? observaciones;

  const OrdenReparacionDto({
    this.id,
    required this.vehiculo,
    required this.vehiculoPlaca,
    this.fechaIngreso,
    this.fechaSalida,
    required this.estado,
    this.observaciones,
  });

  factory OrdenReparacionDto.fromJson(Map<String, dynamic> json) {
    return OrdenReparacionDto(
      id: json['id'] as int?,
      vehiculo: json['vehiculo'] as int,
      vehiculoPlaca: json['vehiculo_placa'] as String? ?? '',
      fechaIngreso: _parseDate(json['fecha_ingreso']),
      fechaSalida: _parseDate(json['fecha_salida']),
      estado: json['estado'] as String? ?? 'pendiente',
      observaciones: json['observaciones'] as String?,
    );
  }

  factory OrdenReparacionDto.fromDomain(OrdenReparacion orden) {
    return OrdenReparacionDto(
      id: orden.id,
      vehiculo: orden.vehiculoId,
      vehiculoPlaca: orden.vehiculoPlaca,
      fechaIngreso: orden.fechaIngreso,
      fechaSalida: orden.fechaSalida,
      estado: orden.estado,
      observaciones: orden.observaciones,
    );
  }

  Map<String, dynamic> toJson() {
    final observacionesLimpias = observaciones?.trim();

    return {
      'vehiculo': vehiculo,
      'estado': estado,
      'fecha_salida': fechaSalida?.toIso8601String(),
      'observaciones':
          observacionesLimpias == null || observacionesLimpias.isEmpty
          ? null
          : observacionesLimpias,
    };
  }

  OrdenReparacion toDomain() {
    return OrdenReparacion(
      id: id,
      vehiculoId: vehiculo,
      vehiculoPlaca: vehiculoPlaca,
      fechaIngreso: fechaIngreso,
      fechaSalida: fechaSalida,
      estado: estado,
      observaciones: observaciones,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }
}
