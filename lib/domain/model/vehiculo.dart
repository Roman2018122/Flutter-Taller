// lib/domain/model/vehiculo.dart

class Vehiculo {
  final int id;
  final String placa; // O patente según como lo manejes en tu API
  final String marca;
  final String modelo;
  final int anio;
  final int clienteId; // Relación con el usuario dueño del auto

  const Vehiculo({
    required this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.clienteId,
  });

  // Transforma el JSON de Django (/api/v1/vehiculos/) a objeto de Flutter
  factory Vehiculo.fromJson(Map<String, dynamic> j) => Vehiculo(
    id: j['id'] as int,
    placa: j['placa'] ?? j['patente'] as String,
    marca: j['marca'] as String,
    modelo: j['modelo'] as String,
    anio: j['anio'] ?? j['year'] as int,
    clienteId: j['cliente'] ?? j['cliente_id'] as int,
  );

  // Transforma el objeto de Flutter a JSON para enviarlo a Django (POST/PUT)
  Map<String, dynamic> toJson() => {
    'placa': placa,
    'marca': marca,
    'modelo': modelo,
    'anio': anio,
    'cliente': clienteId,
  };

  // Clonar el objeto para formularios de edición
  Vehiculo copyWith({
    String? placa,
    String? marca,
    String? modelo,
    int? anio,
    int? clienteId,
  }) => Vehiculo(
    id: id,
    placa: placa ?? this.placa,
    marca: marca ?? this.marca,
    modelo: modelo ?? this.modelo,
    anio: anio ?? this.anio,
    clienteId: clienteId ?? this.clienteId,
  );
}
