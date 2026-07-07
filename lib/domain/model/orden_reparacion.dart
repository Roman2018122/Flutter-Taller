// lib/domain/model/orden_reparacion.dart

class OrdenReparacion {
  final int id;
  final int vehiculoId;
  final String descripcionFalla;
  final String estado; // "PENDIENTE", "EN_PROCESO", "LISTO", etc.
  final int? mecanicoId;
  final String fechaIngreso;

  const OrdenReparacion({
    required this.id,
    required this.vehiculoId,
    required this.descripcionFalla,
    required this.estado,
    this.mecanicoId,
    required this.fechaIngreso,
  });

  factory OrdenReparacion.fromJson(Map<String, dynamic> j) => OrdenReparacion(
    id: j['id'] as int,
    vehiculoId: j['vehiculo'] ?? j['vehiculo_id'] as int,
    descripcionFalla: j['descripcion_falla'] ?? j['falla'] as String,
    estado: j['estado'] as String,
    mecanicoId: j['mecanico'] ?? j['mecanico_id'] as int?,
    fechaIngreso: j['fecha_ingreso'] ?? j['created_at'] as String,
  );

  Map<String, dynamic> toJson() => {
    'vehiculo': vehiculoId,
    'descripcion_falla': descripcionFalla,
    'estado': estado,
    'mecanico': mecanicoId,
  };

  OrdenReparacion copyWith({
    int? vehiculoId,
    String? descripcionFalla,
    String? estado,
    int? mecanicoId,
  }) => OrdenReparacion(
    id: id,
    vehiculoId: vehiculoId ?? this.vehiculoId,
    descripcionFalla: descripcionFalla ?? this.descripcionFalla,
    estado: estado ?? this.estado,
    mecanicoId: mecanicoId ?? this.mecanicoId,
    fechaIngreso: fechaIngreso,
  );
}
