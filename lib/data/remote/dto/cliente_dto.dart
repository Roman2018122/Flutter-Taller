import '../../../domain/model/cliente.dart';

class ClienteDto {
  final int? id;
  final String nombre;
  final String telefono;
  final String correo;
  final String direccion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClienteDto({
    this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
    required this.direccion,
    this.createdAt,
    this.updatedAt,
  });

  factory ClienteDto.fromJson(Map<String, dynamic> json) {
    return ClienteDto(
      id: json['id'] as int?,
      nombre: json['nombre'] as String? ?? '',
      telefono: json['telefono'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      direccion: json['direccion'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  factory ClienteDto.fromDomain(Cliente cliente) {
    return ClienteDto(
      id: cliente.id,
      nombre: cliente.nombre,
      telefono: cliente.telefono,
      correo: cliente.correo,
      direccion: cliente.direccion,
      createdAt: cliente.createdAt,
      updatedAt: cliente.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
      'direccion': direccion,
    };
  }

  Cliente toDomain() {
    return Cliente(
      id: id,
      nombre: nombre,
      telefono: telefono,
      correo: correo,
      direccion: direccion,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
