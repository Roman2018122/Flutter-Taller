import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/detalle_servicio.dart';
import '../../../domain/model/orden_reparacion.dart';
import '../../providers/detalle_servicio_provider.dart';
import 'detalle_servicio_form_screen.dart';
import 'orden_reparacion_form_screen.dart';

class OrdenDetalleScreen extends StatefulWidget {
  final OrdenReparacion orden;

  const OrdenDetalleScreen({super.key, required this.orden});

  @override
  State<OrdenDetalleScreen> createState() => _OrdenDetalleScreenState();
}

class _OrdenDetalleScreenState extends State<OrdenDetalleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.orden.id;

      if (id != null) {
        context.read<DetalleServicioProvider>().cargarPorOrden(id);
      }
    });
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'Sin registrar';
    }

    final local = fecha.toLocal();

    String dosDigitos(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${dosDigitos(local.day)}/'
        '${dosDigitos(local.month)}/'
        '${local.year} '
        '${dosDigitos(local.hour)}:'
        '${dosDigitos(local.minute)}';
  }

  Future<void> _abrirFormulario({DetalleServicio? detalle}) async {
    final ordenId = widget.orden.id;

    if (ordenId == null) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DetalleServicioFormScreen(ordenId: ordenId, detalle: detalle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DetalleServicioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Orden #${widget.orden.id ?? '-'}'),
        actions: [
          IconButton(
            tooltip: 'Editar orden',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      OrdenReparacionFormScreen(orden: widget.orden),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.orden.id == null ? null : () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Agregar servicio'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return provider.cargarPorOrden(widget.orden.id!);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            _buildResumenOrden(),
            const SizedBox(height: 20),
            Text(
              'Servicios realizados',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (provider.isLoading && provider.detalles.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (provider.errorMessage != null && provider.detalles.isEmpty)
              _buildError(provider)
            else if (provider.detalles.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Todavía no se han agregado servicios a esta orden.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              ...provider.detalles.map(_buildDetalleCard),
            const SizedBox(height: 16),
            _buildTotal(provider.totalOrden),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenOrden() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.orden.vehiculoPlaca,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text('Estado: ${widget.orden.estadoVisible}'),
            const SizedBox(height: 6),
            Text('Ingreso: ${_formatearFecha(widget.orden.fechaIngreso)}'),
            const SizedBox(height: 6),
            Text('Salida: ${_formatearFecha(widget.orden.fechaSalida)}'),
            if (widget.orden.observaciones != null &&
                widget.orden.observaciones!.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              Text(widget.orden.observaciones!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleCard(DetalleServicio detalle) {
    final mecanico = detalle.mecanicoNombre.trim().isEmpty
        ? 'Sin asignar'
        : detalle.mecanicoNombre;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.build)),
        title: Text(
          detalle.servicioNombre.isEmpty
              ? 'Servicio #${detalle.servicioId}'
              : detalle.servicioNombre,
        ),
        subtitle: Text(
          'Mecánico: $mecanico\n'
          'Cantidad: ${detalle.cantidad} · '
          'Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}',
        ),
        isThreeLine: true,
        onTap: () {
          _abrirFormulario(detalle: detalle);
        },
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${detalle.subtotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (detalle.id != null)
              InkWell(
                onTap: () {
                  _confirmarEliminar(detalle);
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.delete_outline, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotal(double total) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total de servicios',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(DetalleServicioProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(provider.errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                provider.cargarPorOrden(widget.orden.id!);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(DetalleServicio detalle) async {
    final id = detalle.id;

    if (id == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar servicio'),
          content: Text(
            '¿Deseas quitar "${detalle.servicioNombre}" de esta orden?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final provider = context.read<DetalleServicioProvider>();

    final success = await provider.eliminarDetalle(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Servicio eliminado de la orden.'
              : provider.errorMessage ?? 'No se pudo eliminar.',
        ),
      ),
    );
  }
}
