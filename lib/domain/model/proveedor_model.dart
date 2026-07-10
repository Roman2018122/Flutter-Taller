// lib/domain/model/proveedor_model.dart

class Proveedor {
  final int? id;
  final String ruc; // Identificación fiscal (RUC, NIT, CIF)
  final String razonSocial; // Nombre de la empresa
  final String? telefono;
  final String? email;
  final String? direccion;

  const Proveedor({
    this.id,
    required this.ruc,
    required this.razonSocial,
    this.telefono,
    this.email,
    this.direccion,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json['id'] as int?,
      ruc: (json['ruc'] ?? '').toString(),
      razonSocial: (json['razon_social'] ?? '').toString(),
      telefono: json['telefono']?.toString(),
      email: json['email']?.toString(),
      direccion: json['direccion']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruc': ruc.trim(),
      'razon_social': razonSocial.toUpperCase().trim(),
      'telefono': telefono?.trim(),
      'email': email?.toLowerCase().trim(),
      'direccion': direccion?.trim(),
    };
  }
}