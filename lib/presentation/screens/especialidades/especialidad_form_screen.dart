import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/especialidad.dart';
import '../../providers/especialidad_provider.dart';

class EspecialidadFormScreen extends StatefulWidget {
  final Especialidad? especialidad;

  const EspecialidadFormScreen({super.key, this.especialidad});

  @override
  State<EspecialidadFormScreen> createState() => _EspecialidadFormScreenState();
}

class _EspecialidadFormScreenState extends State<EspecialidadFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;

  late final TextEditingController _descripcionController;

  late bool _estaActiva;

  bool get _isEditing => widget.especialidad != null;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.especialidad?.nombre ?? '',
    );

    _descripcionController = TextEditingController(
      text: widget.especialidad?.descripcion ?? '',
    );

    _estaActiva = widget.especialidad?.estaActiva ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final descripcion = _descripcionController.text.trim();

    final especialidad = Especialidad(
      id: widget.especialidad?.id,
      nombre: _nombreController.text.trim(),
      descripcion: descripcion.isEmpty ? null : descripcion,
      estaActiva: _estaActiva,
    );

    final provider = context.read<EspecialidadProvider>();

    final success = _isEditing
        ? await provider.editarEspecialidad(
            widget.especialidad!.id!,
            especialidad,
          )
        : await provider.crearEspecialidad(especialidad);

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
          provider.errorMessage ?? 'No se pudo guardar la especialidad.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<EspecialidadProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar especialidad' : 'Nueva especialidad'),
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
                  labelText: 'Nombre de la especialidad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final nombre = value?.trim() ?? '';

                  if (nombre.length < 4) {
                    return 'El nombre debe tener al menos 4 caracteres.';
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
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Opcional',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Especialidad activa'),
                subtitle: Text(
                  _estaActiva
                      ? 'Puede asignarse a mecánicos'
                      : 'No está disponible para nuevas asignaciones',
                ),
                value: _estaActiva,
                onChanged: isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _estaActiva = value;
                        });
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
