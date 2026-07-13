class Mecanico {
  final int? id;
  final String nombre;
  final String? telefono;
  final String estado;
  final List<int> especialidadesIds;

  const Mecanico({
    this.id,
    required this.nombre,
    this.telefono,
    required this.estado,
    required this.especialidadesIds,
  });

  bool get estaActivo => estado == 'activo';
}
