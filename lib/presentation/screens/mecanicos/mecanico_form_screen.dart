import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/mecanico.dart';
import '../../providers/especialidad_provider.dart';
import '../../providers/mecanico_provider.dart';

class MecanicoFormScreen extends StatefulWidget {
  final Mecanico? mecanico;

  const MecanicoFormScreen({super.key, this.mecanico});

  @override
  State<MecanicoFormScreen> createState() => _MecanicoFormScreenState();
}

class _MecanicoFormScreenState extends State<MecanicoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _telefonoController;

  late String _estado;
  late Set<int> _especialidadesSeleccionadas;

  bool _catalogoCargado = false;

  bool get _isEditing => widget.mecanico != null;

  @override
  void initState() {
    super.initState();

    _nombreController = TextEditingController(
      text: widget.mecanico?.nombre ?? '',
    );

    _telefonoController = TextEditingController(
      text: widget.mecanico?.telefono ?? '',
    );

    _estado = widget.mecanico?.estado ?? 'activo';

    _especialidadesSeleccionadas = {...?widget.mecanico?.especialidadesIds};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarEspecialidades();
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _cargarEspecialidades() async {
    await context.read<EspecialidadProvider>().cargarEspecialidades();

    if (mounted) {
      setState(() {
        _catalogoCargado = true;
      });
    }
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final telefono = _telefonoController.text.trim();

    final mecanico = Mecanico(
      id: widget.mecanico?.id,
      nombre: _nombreController.text.trim(),
      telefono: telefono.isEmpty ? null : telefono,
      estado: _estado,
      especialidadesIds: _especialidadesSeleccionadas.toList(),
    );

    final provider = context.read<MecanicoProvider>();

    final success = _isEditing
        ? await provider.editarMecanico(widget.mecanico!.id!, mecanico)
        : await provider.crearMecanico(mecanico);

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
          provider.errorMessage ?? 'No se pudo guardar el mecánico.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mecanicoProvider = context.watch<MecanicoProvider>();
    final especialidadProvider = context.watch<EspecialidadProvider>();

    final isLoading =
        mecanicoProvider.isLoading || especialidadProvider.isLoading;

    final especialidadesActivas = especialidadProvider.especialidades
        .where(
          (item) =>
              item.estaActiva ||
              (item.id != null &&
                  _especialidadesSeleccionadas.contains(item.id)),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar mecánico' : 'Nuevo mecánico'),
      ),
      body: !_catalogoCargado && isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                        if ((value?.trim().length ?? 0) < 3) {
                          return 'El nombre debe tener al menos 3 caracteres.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        hintText: 'Opcional',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final telefono = value?.trim() ?? '';

                        if (telefono.isEmpty) {
                          return null;
                        }

                        final limpio = telefono
                            .replaceAll('-', '')
                            .replaceAll('(', '')
                            .replaceAll(')', '')
                            .replaceAll(' ', '')
                            .replaceAll('+', '');

                        if (!RegExp(r'^\d+$').hasMatch(limpio)) {
                          return 'Ingresa un teléfono válido.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _estado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'activo',
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem(
                          value: 'inactivo',
                          child: Text('Inactivo'),
                        ),
                      ],
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value != null) {
                                setState(() {
                                  _estado = value;
                                });
                              }
                            },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Especialidades',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Puedes seleccionar varias especialidades.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    if (especialidadesActivas.isEmpty)
                      const Text('No hay especialidades activas disponibles.')
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: especialidadesActivas.map((especialidad) {
                          final id = especialidad.id;

                          if (id == null) {
                            return const SizedBox.shrink();
                          }

                          final seleccionada = _especialidadesSeleccionadas
                              .contains(id);

                          return FilterChip(
                            label: Text(especialidad.nombre),
                            selected: seleccionada,
                            onSelected: isLoading
                                ? null
                                : (selected) {
                                    setState(() {
                                      if (selected) {
                                        _especialidadesSeleccionadas.add(id);
                                      } else {
                                        _especialidadesSeleccionadas.remove(id);
                                      }
                                    });
                                  },
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: isLoading ? null : _guardar,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: isLoading
                            ? const SizedBox.square(
                                dimension: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
