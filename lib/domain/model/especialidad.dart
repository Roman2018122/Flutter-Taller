class Especialidad {
  final int? id;
  final String nombre;
  final String? descripcion;
  final bool estaActiva;

  const Especialidad({
    this.id,
    required this.nombre,
    this.descripcion,
    required this.estaActiva,
  });
}
