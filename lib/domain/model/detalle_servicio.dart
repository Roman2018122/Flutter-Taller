class DetalleServicio {
  final int? id;
  final int ordenId;

  final int servicioId;
  final String servicioNombre;

  final int? mecanicoId;
  final String mecanicoNombre;

  final int cantidad;
  final double precioUnitario;
  final double subtotal;

  const DetalleServicio({
    this.id,
    required this.ordenId,
    required this.servicioId,
    this.servicioNombre = '',
    this.mecanicoId,
    this.mecanicoNombre = '',
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });

  double get subtotalCalculado {
    return cantidad * precioUnitario;
  }
}
