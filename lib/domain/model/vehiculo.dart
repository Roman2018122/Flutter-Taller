class Vehiculo {
  final int? id;
  final String placa;
  final int anio;

  final int clienteId;
  final String clienteNombre;

  final int modeloVehiculoId;
  final String modeloNombre;
  final String marcaNombre;

  const Vehiculo({
    this.id,
    required this.placa,
    required this.anio,
    required this.clienteId,
    this.clienteNombre = '',
    required this.modeloVehiculoId,
    this.modeloNombre = '',
    this.marcaNombre = '',
  });

  String get descripcionModelo {
    final partes = [
      marcaNombre.trim(),
      modeloNombre.trim(),
    ].where((texto) => texto.isNotEmpty);

    return partes.join(' ');
  }
}

class ModeloVehiculoOption {
  final int id;
  final int marcaId;
  final String marcaNombre;
  final String nombre;
  final String tipoVehiculo;

  const ModeloVehiculoOption({
    required this.id,
    required this.marcaId,
    required this.marcaNombre,
    required this.nombre,
    required this.tipoVehiculo,
  });

  String get descripcion => '$marcaNombre $nombre';
}
