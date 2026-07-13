import '../../../domain/model/detalle_servicio.dart';

class DetalleServicioDto {
  final int? id;
  final int orden;

  final int servicio;
  final String servicioNombre;

  final int? mecanico;
  final String mecanicoNombre;

  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleServicioDto({
    this.id,
    required this.orden,
    required this.servicio,
    required this.servicioNombre,
    this.mecanico,
    required this.mecanicoNombre,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory DetalleServicioDto.fromJson(Map<String, dynamic> json) {
    return DetalleServicioDto(
      id: json['id'] as int?,
      orden: _parseInt(json['orden']),
      servicio: _parseInt(json['servicio']),
      servicioNombre: json['servicio_nombre'] as String? ?? '',
      mecanico: json['mecanico'] == null ? null : _parseInt(json['mecanico']),
      mecanicoNombre: json['mecanico_nombre'] as String? ?? '',
      cantidad: _parseInt(json['cantidad']),
      precioUnitario: _parseDouble(json['precio_unitario']),
      subtotal: _parseDouble(json['subtotal']),
    );
  }

  factory DetalleServicioDto.fromDomain(DetalleServicio detalle) {
    return DetalleServicioDto(
      id: detalle.id,
      orden: detalle.ordenId,
      servicio: detalle.servicioId,
      servicioNombre: detalle.servicioNombre,
      mecanico: detalle.mecanicoId,
      mecanicoNombre: detalle.mecanicoNombre,
      cantidad: detalle.cantidad,
      precioUnitario: detalle.precioUnitario,
      subtotal: detalle.subtotal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orden': orden,
      'servicio': servicio,
      'mecanico': mecanico,
      'cantidad': cantidad,
      'precio_unitario': precioUnitario.toStringAsFixed(2),
    };
  }

  DetalleServicio toDomain() {
    return DetalleServicio(
      id: id,
      ordenId: orden,
      servicioId: servicio,
      servicioNombre: servicioNombre,
      mecanicoId: mecanico,
      mecanicoNombre: mecanicoNombre,
      cantidad: cantidad,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
