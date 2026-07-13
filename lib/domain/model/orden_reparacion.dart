class OrdenReparacion {
  final int? id;
  final int vehiculoId;
  final String vehiculoPlaca;
  final DateTime? fechaIngreso;
  final DateTime? fechaSalida;
  final String estado;
  final String? observaciones;

  const OrdenReparacion({
    this.id,
    required this.vehiculoId,
    this.vehiculoPlaca = '',
    this.fechaIngreso,
    this.fechaSalida,
    required this.estado,
    this.observaciones,
  });

  String get estadoVisible {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'en_proceso':
        return 'En proceso';
      case 'finalizado':
        return 'Finalizado';
      default:
        return estado;
    }
  }
}
