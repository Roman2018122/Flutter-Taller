import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/servicio.dart';
import '../../providers/servicio_provider.dart';

class ServicioFormScreen extends StatefulWidget {
  final Servicio? servicio;

  const ServicioFormScreen({super.key, this.servicio});

  @override
  State<ServicioFormScreen> createState() => _ServicioFormScreenState();
}

class _ServicioFormScreenState extends State<ServicioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _precioController;

  bool get _isEditing => widget.servicio != null;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.servicio?.nombre ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.servicio?.descripcion ?? '',
    );

    _precioController = TextEditingController(
      text: widget.servicio == null
          ? ''
          : widget.servicio!.precioReferencial.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final precio = double.tryParse(
      _precioController.text.trim().replaceAll(',', '.'),
    );

    if (precio == null) {
      return;
    }

    final servicio = Servicio(
      id: widget.servicio?.id,
      nombre: _nombreController.text.trim(),
      descripcion: _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
      precioReferencial: precio,
    );

    final provider = context.read<ServicioProvider>();

    final success = _isEditing
        ? await provider.editarServicio(widget.servicio!.id!, servicio)
        : await provider.crearServicio(servicio);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage ?? 'No se pudo guardar el servicio.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<ServicioProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar servicio' : 'Nuevo servicio'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nombreController,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final nombre = value?.trim() ?? '';

                  if (nombre.length < 3) {
                    return 'El nombre debe tener al menos 3 caracteres.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                enabled: !isLoading,
                minLines: 3,
                maxLines: 5,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Opcional',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precioController,
                enabled: !isLoading,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*[.,]?\d{0,2}'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Precio referencial',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final precio = double.tryParse(
                    (value ?? '').trim().replaceAll(',', '.'),
                  );

                  if (precio == null) {
                    return 'Ingresa un precio válido.';
                  }

                  if (precio <= 0) {
                    return 'El precio debe ser mayor que cero.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isLoading ? null : _guardar,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: isLoading
                      ? const SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
