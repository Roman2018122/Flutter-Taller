// lib/presentation/screens/repuesto/repuesto_form_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/repuesto_model.dart';
import 'package:taller_mecanico_app/main.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';

class RepuestoFormScreen extends StatefulWidget {
  final Repuesto? repuesto;

  const RepuestoFormScreen({super.key, this.repuesto});

  @override
  State<RepuestoFormScreen> createState() => _RepuestoFormScreenState();
}

class _RepuestoFormScreenState extends State<RepuestoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoCtrl = TextEditingController();
  final _nombreCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _stockMinCtrl = TextEditingController();
  
  int? _selectedProveedorId; // 🛠️ Guardará la FK del proveedor seleccionado
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 🛠️ Forzamos la carga de proveedores al entrar al formulario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.proveedorProvider.cargarProveedores();
    });

    if (widget.repuesto != null) {
      _codigoCtrl.text = widget.repuesto!.codigo;
      _nombreCtrl.text = widget.repuesto!.nombre;
      _descCtrl.text = widget.repuesto!.descripcion ?? '';
      _precioCtrl.text = widget.repuesto!.precioVenta.toString();
      _stockCtrl.text = widget.repuesto!.stockActual.toString();
      _stockMinCtrl.text = widget.repuesto!.stockMinimo.toString();
      _selectedProveedorId = widget.repuesto!.proveedorId;
    } else {
      _stockCtrl.text = '0';
      _stockMinCtrl.text = '5';
    }
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _stockMinCtrl.dispose();
    super.dispose();
  }

  void _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProveedorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona un proveedor comercial.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isSaving = true);

    final repuestoData = Repuesto(
      id: widget.repuesto?.id,
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      precioVenta: double.parse(_precioCtrl.text),
      stockActual: int.parse(_stockCtrl.text),
      stockMinimo: int.parse(_stockMinCtrl.text),
      proveedorId: _selectedProveedorId, // 🛠️ Pasamos el ID del proveedor
    );

    bool exito;
    if (widget.repuesto == null) {
      exito = await context.repuestoProvider.agregarRepuesto(repuestoData);
    } else {
      exito = await context.repuestoProvider.modificarRepuesto(repuestoData);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.repuesto == null ? 'Repuesto registrado en almacén' : 'Inventario actualizado correctamente')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${context.repuestoProvider.errorMessage}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.repuesto != null;
    final proveedores = context.proveedorProvider.proveedores; // 🛠️ Consumimos la lista de proveedores

    return Scaffold(
      appBar: AppBar(title: Text(esEdicion ? 'MODIFICAR PIEZA' : 'REGISTRAR EN INVENTARIO')),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _codigoCtrl,
                      decoration: const InputDecoration(labelText: 'Código SKU / Barras *', prefixIcon: Icon(Icons.qr_code_rounded)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'El código es requerido' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(labelText: 'Nombre del Repuesto *', prefixIcon: Icon(Icons.handyman_rounded)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'El nombre es requerido' : null,
                    ),
                    const SizedBox(height: 14),
                    
                    // 🛠️ NUEVO DESPLEGABLE DE PROVEEDORES INTEGRADO:
                    DropdownButtonFormField<int>(
                      value: _selectedProveedorId,
                      decoration: const InputDecoration(labelText: 'Proveedor Asignado *', prefixIcon: Icon(Icons.business_rounded)),
                      items: proveedores.map((p) => DropdownMenuItem(value: p.id, child: Text(p.razonSocial))).toList(),
                      onChanged: (val) => setState(() => _selectedProveedorId = val),
                      validator: (v) => v == null ? 'Selecciona quién provee este artículo' : null,
                    ),
                    const SizedBox(height: 14),

                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: 'Especificaciones / Marca física', prefixIcon: Icon(Icons.description_rounded)),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _precioCtrl,
                      decoration: const InputDecoration(labelText: 'Precio de Venta (\$)*', prefixIcon: Icon(Icons.monetization_on_rounded)),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) => double.tryParse(v ?? '') == null ? 'Introduce un precio válido' : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _stockCtrl,
                            decoration: const InputDecoration(labelText: 'Stock Inicial', prefixIcon: Icon(Icons.inventory_2_rounded)),
                            keyboardType: TextInputType.number,
                            validator: (v) => int.tryParse(v ?? '') == null ? 'Número inválido' : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextFormField(
                            controller: _stockMinCtrl,
                            decoration: const InputDecoration(labelText: 'Stock Mínimo Alerta', prefixIcon: Icon(Icons.warning_amber_rounded)),
                            keyboardType: TextInputType.number,
                            validator: (v) => int.tryParse(v ?? '') == null ? 'Número inválido' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        onPressed: _guardarFormulario,
                        child: Text(
                          esEdicion ? 'ACTUALIZAR INVENTARIO' : 'INGRESAR AL ALMACÉN',
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}