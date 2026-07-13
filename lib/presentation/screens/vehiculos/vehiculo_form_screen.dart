import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/vehiculo.dart';
import '../../providers/cliente_provider.dart';
import '../../providers/vehiculo_provider.dart';

class VehiculoFormScreen extends StatefulWidget {
  final Vehiculo? vehiculo;

  const VehiculoFormScreen({super.key, this.vehiculo});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _placaController;
  late final TextEditingController _anioController;

  int? _clienteId;
  int? _modeloVehiculoId;
  bool _catalogosCargados = false;

  bool get _isEditing => widget.vehiculo != null;

  @override
  void initState() {
    super.initState();

    _placaController = TextEditingController(
      text: widget.vehiculo?.placa ?? '',
    );

    _anioController = TextEditingController(
      text: widget.vehiculo?.anio.toString() ?? DateTime.now().year.toString(),
    );

    _clienteId = widget.vehiculo?.clienteId;
    _modeloVehiculoId = widget.vehiculo?.modeloVehiculoId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCatalogos();
    });
  }

  @override
  void dispose() {
    _placaController.dispose();
    _anioController.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogos() async {
    final clienteProvider = context.read<ClienteProvider>();
    final vehiculoProvider = context.read<VehiculoProvider>();

    await Future.wait([
      clienteProvider.cargarClientes(),
      vehiculoProvider.cargarModelos(),
    ]);

    if (mounted) {
      setState(() {
        _catalogosCargados = true;
      });
    }
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final anio = int.tryParse(_anioController.text.trim());

    if (anio == null || _clienteId == null || _modeloVehiculoId == null) {
      return;
    }

    final vehiculo = Vehiculo(
      id: widget.vehiculo?.id,
      placa: _placaController.text.trim().toUpperCase(),
      anio: anio,
      clienteId: _clienteId!,
      modeloVehiculoId: _modeloVehiculoId!,
      clienteNombre: widget.vehiculo?.clienteNombre ?? '',
      modeloNombre: widget.vehiculo?.modeloNombre ?? '',
      marcaNombre: widget.vehiculo?.marcaNombre ?? '',
    );

    final provider = context.read<VehiculoProvider>();

    final success = _isEditing
        ? await provider.editarVehiculo(widget.vehiculo!.id!, vehiculo)
        : await provider.crearVehiculo(vehiculo);

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
          provider.errorMessage ?? 'No se pudo guardar el vehículo.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoProvider = context.watch<VehiculoProvider>();

    final clienteProvider = context.watch<ClienteProvider>();

    final isLoading = vehiculoProvider.isLoading || clienteProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar vehículo' : 'Nuevo vehículo'),
      ),
      body: !_catalogosCargados && isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _placaController,
                    enabled: !isLoading,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final placa = value?.trim() ?? '';

                      if (placa.length < 5) {
                        return 'La placa debe tener al menos 5 caracteres.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _anioController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Año',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final anio = int.tryParse(value?.trim() ?? '');

                      final maximo = DateTime.now().year + 1;

                      if (anio == null) {
                        return 'Ingresa un año válido.';
                      }

                      if (anio < 1950 || anio > maximo) {
                        return 'El año debe estar entre 1950 y $maximo.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _clienteId,
                    decoration: const InputDecoration(
                      labelText: 'Cliente',
                      border: OutlineInputBorder(),
                    ),
                    items: clienteProvider.clientes.map((cliente) {
                      return DropdownMenuItem<int>(
                        value: cliente.id,
                        child: Text(cliente.nombre),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _clienteId = value;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona un cliente.';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: _modeloVehiculoId,
                    decoration: const InputDecoration(
                      labelText: 'Modelo de vehículo',
                      border: OutlineInputBorder(),
                    ),
                    items: vehiculoProvider.modelos.map((modelo) {
                      return DropdownMenuItem<int>(
                        value: modelo.id,
                        child: Text(modelo.descripcion),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _modeloVehiculoId = value;
                            });
                          },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona un modelo.';
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
    );
  }
}
