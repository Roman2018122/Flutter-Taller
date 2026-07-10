// lib/presentation/screens/proveedor/proveedor_form_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/proveedor_model.dart';
import 'package:taller_mecanico_app/main.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';

class ProveedorFormScreen extends StatefulWidget {
  final Proveedor? proveedor;

  const ProveedorFormScreen({super.key, this.proveedor});

  @override
  State<ProveedorFormScreen> createState() => _ProveedorFormScreenState();
}

class _ProveedorFormScreenState extends State<ProveedorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rucCtrl = TextEditingController();
  final _razonSocialCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      _rucCtrl.text = widget.proveedor!.ruc;
      _razonSocialCtrl.text = widget.proveedor!.razonSocial;
      _telefonoCtrl.text = widget.proveedor!.telefono ?? '';
      _emailCtrl.text = widget.proveedor!.email ?? '';
      _direccionCtrl.text = widget.proveedor!.direccion ?? '';
    }
  }

  @override
  void dispose() {
    _rucCtrl.dispose();
    _razonSocialCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  void _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final proveedorData = Proveedor(
      id: widget.proveedor?.id,
      ruc: _rucCtrl.text.trim(),
      razonSocial: _razonSocialCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
    );

    bool exito;
    if (widget.proveedor == null) {
      exito = await context.proveedorProvider.agregarProveedor(proveedorData);
    } else {
      exito = await context.proveedorProvider.modificarProveedor(proveedorData);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.proveedor == null ? 'Proveedor registrado' : 'Datos del proveedor actualizados')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${context.proveedorProvider.errorMessage}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.proveedor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'MODIFICAR PROVEEDOR' : 'REGISTRAR PROVEEDOR'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _rucCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Identificación Fiscal (RUC/NIT/CIF) *',
                        prefixIcon: Icon(Icons.badge_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _razonSocialCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre / Razón Social *',
                        prefixIcon: Icon(Icons.business_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'La razón social es obligatoria' : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _telefonoCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono de Contacto',
                        prefixIcon: Icon(Icons.phone_rounded),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _direccionCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Dirección Comercial',
                        prefixIcon: Icon(Icons.location_on_rounded),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        onPressed: _guardarFormulario,
                        child: Text(
                          esEdicion ? 'ACTUALIZAR PROVEEDOR' : 'DAR DE ALTA PROVEEDOR',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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