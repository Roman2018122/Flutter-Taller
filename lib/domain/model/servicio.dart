// lib/domain/model/servicio.dart

class Servicio {
  final int id;
  final String nombre;
  final String descripcion;
  final double precioEstandar;

  const Servicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioEstandar,
  });

  // Transforma el JSON que viene de Django (/api/v1/servicios/) a objeto de Flutter
  factory Servicio.fromJson(Map<String, dynamic> j) => Servicio(
    id: j['id'] as int,
    nombre: j['nombre'] as String,
    descripcion: j['descripcion'] ?? '' as String,
    // Django suele mandar los precios como String o double, nos aseguramos de parsearlo bien:
    precioEstandar: (j['precio_estandar'] is String)
        ? double.parse(j['precio_estandar'])
        : (j['precio_estandar'] as num).toDouble(),
  );

  // Transforma el objeto de Flutter a un JSON para enviarlo a Django (POST/PUT)
  Map<String, dynamic> toJson() => {
    'nombre': nombre,
    'descripcion': descripcion,
    'precio_estandar': precioEstandar,
  };

  // Permite clonar el objeto modificando solo algunos campos (útil para formularios de edición)
  Servicio copyWith({
    String? nombre,
    String? descripcion,
    double? precioEstandar,
  }) => Servicio(
    id: id,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion ?? this.descripcion,
    precioEstandar: precioEstandar ?? this.precioEstandar,
  );
}
