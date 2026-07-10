// lib/domain/model/vehiculo_model.dart

class Vehiculo {
  final int? id;
  final String placa;
  final int clienteId;
  final int marcaId;
  final String? modelo;
  final int? anio;
  final String? color;
  final String? chasis;
  
  // Campos auxiliares para mostrar texto en las listas sin re-consultar
  final String? clienteNombre;
  final String? marcaNombre;

  Vehiculo({
    this.id,
    required this.placa,
    required this.clienteId,
    required this.marcaId,
    this.modelo,
    this.anio,
    this.color,
    this.chasis,
    this.clienteNombre,
    this.marcaNombre,
  });

  // Convierte un JSON de Django a un objeto Vehiculo de Flutter
  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      id: json['id'],
      placa: json['placa'] ?? '',
      clienteId: json['cliente'],
      marcaId: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      color: json['color'],
      chasis: json['chasis'],
      clienteNombre: json['cliente_nombre'],
      marcaNombre: json['marca_nombre'],
    );
  }

  // Convierte nuestro objeto a JSON para mandarlo a la API de Django
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'placa': placa.toUpperCase().trim(),
      'cliente': clienteId,
      'marca': marcaId,
      'modelo': modelo?.trim(),
      'anio': anio,
      'color': color?.trim(),
      'chasis': chasis?.toUpperCase().trim(),
    };
    if (id != null) data['id'] = id;
    return data;
  }
}