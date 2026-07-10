// lib/domain/model/repuesto_model.dart

class Repuesto {
  final int? id;
  final String codigo; 
  final String nombre;
  final String? descripcion;
  final double precioVenta;
  final int stockActual;
  final int stockMinimo; 
  final int? proveedorId;      // 🛠️ Enlace con la tabla de proveedores
  final String? proveedorNombre; // 🛠️ Para mostrar en la interfaz de usuario sin reconsultar

  const Repuesto({
    this.id,
    required this.codigo,
    required this.nombre,
    this.descripcion,
    required this.precioVenta,
    required this.stockActual,
    this.stockMinimo = 5,
    this.proveedorId,         // 🛠️ Añadido opcional
    this.proveedorNombre,     // 🛠️ Añadido opcional
  });

  factory Repuesto.fromMap(Map<String, dynamic> map) {
    return Repuesto(
      id: map['id'] as int?,
      codigo: (map['codigo'] ?? '').toString(),
      nombre: (map['nombre'] ?? '').toString(),
      descripcion: map['descripcion']?.toString(),
      precioVenta: double.tryParse(map['precio_venta'].toString()) ?? 0.0,
      stockActual: map['stock_actual'] as int? ?? 0,
      stockMinimo: map['stock_minimo'] as int? ?? 5,
      proveedorId: map['proveedor'] as int?,               // 🛠️ Mapeo desde Django
      proveedorNombre: map['proveedor_nombre']?.toString(), // 🛠️ Mapeo desde Django
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'codigo': codigo.toUpperCase().trim(),
      'nombre': nombre.trim(),
      'descripcion': descripcion?.trim(),
      'precio_venta': precioVenta,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'proveedor_id': proveedorId, // 🛠️ Enviado como FK a Django
    };
  }
}