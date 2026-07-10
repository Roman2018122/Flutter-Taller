// lib/presentation/screens/client/cliente_form_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/cliente_model.dart';
import 'package:taller_mecanico_app/main.dart'; // Para context.clienteProvider
import 'package:taller_mecanico_app/theme/app_colors.dart';

class ClienteFormScreen extends StatefulWidget {
  final Cliente? cliente; // Si viene un cliente, la pantalla se comporta como "Editar"

  const ClienteFormScreen({super.key, this.cliente});

  @override
  State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para los campos de texto
  final _nombresCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _cedulaCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Si estamos editando, precargamos los datos del cliente en los inputs
    if (widget.cliente != null) {
      _nombresCtrl.text = widget.cliente!.nombres;
      _apellidosCtrl.text = widget.cliente!.apellidos;
      _cedulaCtrl.text = widget.cliente!.cedulaIdentidad;
      _telefonoCtrl.text = widget.cliente!.telefono ?? '';
      _emailCtrl.text = widget.cliente!.email ?? '';
      _direccionCtrl.text = widget.cliente!.direccion ?? '';
    }
  }

  @override
  void dispose() {
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _cedulaCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    _direccionCtrl.dispose();
    super.dispose();
  }

  void _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    // Creamos la instancia del objeto con los datos del formulario
    final clienteData = Cliente(
      id: widget.cliente?.id, // Conserva el ID si estamos editando
      nombres: _nombresCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      cedulaIdentidad: _cedulaCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim().isEmpty ? null : _direccionCtrl.text.trim(),
    );

    bool exito = false;
    if (widget.cliente == null) {
      // Guardar nuevo en Django (POST)
      exito = await context.clienteProvider.agregarCliente(clienteData);
    } else {
      // Actualizar existente en Django (PUT)
      exito = await context.clienteProvider.modificarCliente(clienteData);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.cliente == null ? 'Cliente guardado con éxito' : 'Cliente actualizado con éxito')),
        );
        Navigator.pop(context); // Regresa a la lista de clientes automáticamente
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${context.clienteProvider.errorMessage}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'EDITAR CLIENTE' : 'NUEVO CLIENTE'),
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
                      controller: _nombresCtrl,
                      decoration: const InputDecoration(labelText: 'Nombres *', prefixIcon: Icon(Icons.person)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _apellidosCtrl,
                      decoration: const InputDecoration(labelText: 'Apellidos *', prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cedulaCtrl,
                      decoration: const InputDecoration(labelText: 'Cédula de Identidad *', prefixIcon: Icon(Icons.badge_rounded)),
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Este campo es obligatorio' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _telefonoCtrl,
                      decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _direccionCtrl,
                      decoration: const InputDecoration(labelText: 'Dirección de Domicilio', prefixIcon: Icon(Icons.location_on)),
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
                          esEdicion ? 'ACTUALIZAR DATOS' : 'REGISTRAR CLIENTE',
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