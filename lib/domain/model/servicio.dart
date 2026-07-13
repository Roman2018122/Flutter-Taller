class Servicio {
  final int? id;
  final String nombre;
  final String? descripcion;
  final double precioReferencial;

  const Servicio({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.precioReferencial,
  });
}
