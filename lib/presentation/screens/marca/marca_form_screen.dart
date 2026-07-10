// lib/presentation/screens/marca/marca_form_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/domain/model/marca_model.dart';
import 'package:taller_mecanico_app/main.dart'; // Para context.marcaProvider
import 'package:taller_mecanico_app/theme/app_colors.dart';

class MarcaFormScreen extends StatefulWidget {
  final Marca? marca;

  const MarcaFormScreen({super.key, this.marca});

  @override
  State<MarcaFormScreen> createState() => _MarcaFormScreenState();
}

class _MarcaFormScreenState extends State<MarcaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.marca != null) {
      _nombreCtrl.text = widget.marca!.nombre;
      _descCtrl.text = widget.marca!.descripcion ?? '';
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final marcaData = Marca(
      id: widget.marca?.id,
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
    );

    bool exito = false;
    if (widget.marca == null) {
      exito = await context.marcaProvider.agregarMarca(marcaData);
    } else {
      exito = await context.marcaProvider.modificarMarca(marcaData);
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.marca == null ? 'Marca registrada con éxito' : 'Marca actualizada con éxito')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${context.marcaProvider.errorMessage}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.marca != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'EDITAR MARCA' : 'NUEVA MARCA'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la Marca *',
                        prefixIcon: Icon(Icons.branding_watermark_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'El nombre es obligatorio' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Descripción / Notas',
                        prefixIcon: Icon(Icons.description_rounded),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                        onPressed: _guardarFormulario,
                        child: Text(
                          esEdicion ? 'ACTUALIZAR MARCA' : 'REGISTRAR MARCA',
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