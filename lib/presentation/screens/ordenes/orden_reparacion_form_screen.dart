import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/orden_reparacion.dart';
import '../../providers/orden_reparacion_provider.dart';
import '../../providers/vehiculo_provider.dart';

import 'orden_detalle_screen.dart';

class OrdenReparacionFormScreen extends StatefulWidget {
  final OrdenReparacion? orden;

  const OrdenReparacionFormScreen({super.key, this.orden});

  @override
  State<OrdenReparacionFormScreen> createState() =>
      _OrdenReparacionFormScreenState();
}

class _OrdenReparacionFormScreenState extends State<OrdenReparacionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _observacionesController;

  int? _vehiculoId;
  late String _estado;
  DateTime? _fechaSalida;
  bool _vehiculosCargados = false;

  bool get _isEditing => widget.orden != null;

  @override
  void initState() {
    super.initState();

    _vehiculoId = widget.orden?.vehiculoId;
    _estado = widget.orden?.estado ?? 'pendiente';
    _fechaSalida = widget.orden?.fechaSalida;

    _observacionesController = TextEditingController(
      text: widget.orden?.observaciones ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarVehiculos();
    });
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _cargarVehiculos() async {
    await context.read<VehiculoProvider>().cargarVehiculos();

    if (mounted) {
      setState(() {
        _vehiculosCargados = true;
      });
    }
  }

  Future<void> _seleccionarFechaSalida() async {
    final fechaInicial = _fechaSalida ?? DateTime.now();

    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaInicial,
      firstDate:
          widget.orden?.fechaIngreso?.toLocal() ??
          DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (fecha == null || !mounted) {
      return;
    }

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaInicial),
    );

    if (hora == null) {
      return;
    }

    setState(() {
      _fechaSalida = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
    });
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'Sin fecha de salida';
    }

    final local = fecha.toLocal();

    String dosDigitos(int value) => value.toString().padLeft(2, '0');

    return '${dosDigitos(local.day)}/'
        '${dosDigitos(local.month)}/'
        '${local.year} '
        '${dosDigitos(local.hour)}:'
        '${dosDigitos(local.minute)}';
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_vehiculoId == null) {
      return;
    }

    if (_estado == 'finalizado' && _fechaSalida == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona una fecha de salida para finalizar la orden.',
          ),
        ),
      );
      return;
    }

    final observaciones = _observacionesController.text.trim();

    final orden = OrdenReparacion(
      id: widget.orden?.id,
      vehiculoId: _vehiculoId!,
      vehiculoPlaca: widget.orden?.vehiculoPlaca ?? '',
      fechaIngreso: widget.orden?.fechaIngreso,
      fechaSalida: _fechaSalida,
      estado: _estado,
      observaciones: observaciones.isEmpty ? null : observaciones,
    );

    final provider = context.read<OrdenReparacionProvider>();

    final success = _isEditing
        ? await provider.editarOrden(widget.orden!.id!, orden)
        : await provider.crearOrden(orden);

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pop(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(provider.errorMessage ?? 'No se pudo guardar la orden.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordenProvider = context.watch<OrdenReparacionProvider>();

    final vehiculoProvider = context.watch<VehiculoProvider>();

    final isLoading = ordenProvider.isLoading || vehiculoProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar orden' : 'Nueva orden')),
      body: !_vehiculosCargados && isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _vehiculoId,
                      decoration: const InputDecoration(
                        labelText: 'Vehículo',
                        border: OutlineInputBorder(),
                      ),
                      items: vehiculoProvider.vehiculos
                          .where((vehiculo) => vehiculo.id != null)
                          .map(
                            (vehiculo) => DropdownMenuItem<int>(
                              value: vehiculo.id,
                              child: Text(
                                '${vehiculo.placa}'
                                ' · ${vehiculo.descripcionModelo}'
                                ' · ${vehiculo.clienteNombre}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _vehiculoId = value;
                              });
                            },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un vehículo.';
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
                          value: 'pendiente',
                          child: Text('Pendiente'),
                        ),
                        DropdownMenuItem(
                          value: 'en_proceso',
                          child: Text('En proceso'),
                        ),
                        DropdownMenuItem(
                          value: 'finalizado',
                          child: Text('Finalizado'),
                        ),
                      ],
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }

                              setState(() {
                                _estado = value;

                                if (value != 'finalizado') {
                                  _fechaSalida = null;
                                }
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Fecha de salida'),
                      subtitle: Text(_formatearFecha(_fechaSalida)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_fechaSalida != null)
                            IconButton(
                              tooltip: 'Quitar fecha',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _fechaSalida = null;
                                      });
                                    },
                              icon: const Icon(Icons.clear),
                            ),
                          IconButton(
                            tooltip: 'Seleccionar fecha',
                            onPressed: isLoading
                                ? null
                                : _seleccionarFechaSalida,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _observacionesController,
                      enabled: !isLoading,
                      minLines: 4,
                      maxLines: 7,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones',
                        hintText: 'Opcional',
                        border: OutlineInputBorder(),
                      ),
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
