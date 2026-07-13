import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/detalle_servicio.dart';
import '../../providers/detalle_servicio_provider.dart';
import '../../providers/mecanico_provider.dart';
import '../../providers/servicio_provider.dart';

import '../../../domain/model/servicio.dart';

class DetalleServicioFormScreen extends StatefulWidget {
  final int ordenId;
  final DetalleServicio? detalle;

  const DetalleServicioFormScreen({
    super.key,
    required this.ordenId,
    this.detalle,
  });

  @override
  State<DetalleServicioFormScreen> createState() =>
      _DetalleServicioFormScreenState();
}

class _DetalleServicioFormScreenState extends State<DetalleServicioFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _cantidadController;

  late final TextEditingController _precioController;

  int? _servicioId;
  int? _mecanicoId;

  bool _catalogosCargados = false;

  bool get _isEditing => widget.detalle != null;

  @override
  void initState() {
    super.initState();

    _servicioId = widget.detalle?.servicioId;
    _mecanicoId = widget.detalle?.mecanicoId;

    _cantidadController = TextEditingController(
      text: widget.detalle?.cantidad.toString() ?? '1',
    );

    _precioController = TextEditingController(
      text: widget.detalle == null
          ? ''
          : widget.detalle!.precioUnitario.toStringAsFixed(2),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarCatalogos();
    });
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _cargarCatalogos() async {
    await Future.wait([
      context.read<ServicioProvider>().cargarServicios(),
      context.read<MecanicoProvider>().cargarMecanicos(),
    ]);

    if (mounted) {
      setState(() {
        _catalogosCargados = true;
      });
    }
  }

  void _seleccionarServicio(int? servicioId) {
    setState(() {
      _servicioId = servicioId;

      if (!_isEditing && servicioId != null) {
        final servicios = context.read<ServicioProvider>().servicios;

        final servicio = servicios
            .where((item) => item.id == servicioId)
            .firstOrNull;

        if (servicio != null) {
          _precioController.text = servicio.precioReferencial.toStringAsFixed(
            2,
          );
        }
      }
    });
  }

  double get _subtotalVista {
    final cantidad = int.tryParse(_cantidadController.text.trim()) ?? 0;

    final precio =
        double.tryParse(_precioController.text.trim().replaceAll(',', '.')) ??
        0;

    return cantidad * precio;
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final cantidad = int.parse(_cantidadController.text.trim());

    final precio = double.parse(
      _precioController.text.trim().replaceAll(',', '.'),
    );

    final detalle = DetalleServicio(
      id: widget.detalle?.id,
      ordenId: widget.ordenId,
      servicioId: _servicioId!,
      servicioNombre: widget.detalle?.servicioNombre ?? '',
      mecanicoId: _mecanicoId,
      mecanicoNombre: widget.detalle?.mecanicoNombre ?? '',
      cantidad: cantidad,
      precioUnitario: precio,
      subtotal: cantidad * precio,
    );

    final provider = context.read<DetalleServicioProvider>();

    final success = _isEditing
        ? await provider.editarDetalle(widget.detalle!.id!, detalle)
        : await provider.crearDetalle(detalle);

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
    final detalleProvider = context.watch<DetalleServicioProvider>();

    final servicioProvider = context.watch<ServicioProvider>();

    final mecanicoProvider = context.watch<MecanicoProvider>();

    final isLoading =
        detalleProvider.isLoading ||
        servicioProvider.isLoading ||
        mecanicoProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar servicio' : 'Agregar servicio'),
      ),
      body: !_catalogosCargados && isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _servicioId,
                      decoration: const InputDecoration(
                        labelText: 'Servicio',
                        border: OutlineInputBorder(),
                      ),
                      items: servicioProvider.servicios
                          .where((servicio) => servicio.id != null)
                          .map(
                            (servicio) => DropdownMenuItem<int>(
                              value: servicio.id,
                              child: Text(
                                '${servicio.nombre} · '
                                '\$${servicio.precioReferencial.toStringAsFixed(2)}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: isLoading ? null : _seleccionarServicio,
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un servicio.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int?>(
                      initialValue: _mecanicoId,
                      decoration: const InputDecoration(
                        labelText: 'Mecánico',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Sin asignar'),
                        ),
                        ...mecanicoProvider.mecanicos
                            .where(
                              (mecanico) =>
                                  mecanico.id != null && mecanico.estaActivo,
                            )
                            .map(
                              (mecanico) => DropdownMenuItem<int?>(
                                value: mecanico.id,
                                child: Text(mecanico.nombre),
                              ),
                            ),
                      ],
                      onChanged: isLoading
                          ? null
                          : (value) {
                              setState(() {
                                _mecanicoId = value;
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _cantidadController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Cantidad',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      validator: (value) {
                        final cantidad = int.tryParse(value?.trim() ?? '');

                        if (cantidad == null || cantidad < 1) {
                          return 'La cantidad debe ser al menos 1.';
                        }

                        return null;
                      },
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
                        labelText: 'Precio unitario',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      validator: (value) {
                        final precio = double.tryParse(
                          (value ?? '').trim().replaceAll(',', '.'),
                        );

                        if (precio == null || precio <= 0) {
                          return 'Ingresa un precio mayor que cero.';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Card(
                      child: ListTile(
                        title: const Text('Subtotal'),
                        trailing: Text(
                          '\$${_subtotalVista.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
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
                            : Text(_isEditing ? 'Actualizar' : 'Agregar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
