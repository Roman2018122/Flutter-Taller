import '../../../domain/model/vehiculo.dart';

class VehiculoDto {
  final int? id;
  final String placa;
  final int anio;
  final int cliente;
  final String clienteNombre;
  final int modeloVehiculo;
  final String modeloNombre;
  final String marcaNombre;

  const VehiculoDto({
    this.id,
    required this.placa,
    required this.anio,
    required this.cliente,
    required this.clienteNombre,
    required this.modeloVehiculo,
    required this.modeloNombre,
    required this.marcaNombre,
  });

  factory VehiculoDto.fromJson(Map<String, dynamic> json) {
    return VehiculoDto(
      id: json['id'] as int?,
      placa: json['placa'] as String? ?? '',
      anio: json['anio'] as int? ?? 0,
      cliente: json['cliente'] as int,
      clienteNombre: json['cliente_nombre'] as String? ?? '',
      modeloVehiculo: json['modelo_vehiculo'] as int,
      modeloNombre: json['modelo_nombre'] as String? ?? '',
      marcaNombre: json['marca_nombre'] as String? ?? '',
    );
  }

  factory VehiculoDto.fromDomain(Vehiculo vehiculo) {
    return VehiculoDto(
      id: vehiculo.id,
      placa: vehiculo.placa,
      anio: vehiculo.anio,
      cliente: vehiculo.clienteId,
      clienteNombre: vehiculo.clienteNombre,
      modeloVehiculo: vehiculo.modeloVehiculoId,
      modeloNombre: vehiculo.modeloNombre,
      marcaNombre: vehiculo.marcaNombre,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placa': placa,
      'anio': anio,
      'cliente': cliente,
      'modelo_vehiculo': modeloVehiculo,
    };
  }

  Vehiculo toDomain() {
    return Vehiculo(
      id: id,
      placa: placa,
      anio: anio,
      clienteId: cliente,
      clienteNombre: clienteNombre,
      modeloVehiculoId: modeloVehiculo,
      modeloNombre: modeloNombre,
      marcaNombre: marcaNombre,
    );
  }
}

class ModeloVehiculoOptionDto {
  final int id;
  final int marca;
  final String marcaNombre;
  final String nombre;
  final String tipoVehiculo;

  const ModeloVehiculoOptionDto({
    required this.id,
    required this.marca,
    required this.marcaNombre,
    required this.nombre,
    required this.tipoVehiculo,
  });

  factory ModeloVehiculoOptionDto.fromJson(Map<String, dynamic> json) {
    return ModeloVehiculoOptionDto(
      id: json['id'] as int,
      marca: json['marca'] as int,
      marcaNombre: json['marca_nombre'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      tipoVehiculo: json['tipo_vehiculo'] as String? ?? '',
    );
  }

  ModeloVehiculoOption toDomain() {
    return ModeloVehiculoOption(
      id: id,
      marcaId: marca,
      marcaNombre: marcaNombre,
      nombre: nombre,
      tipoVehiculo: tipoVehiculo,
    );
  }
}
