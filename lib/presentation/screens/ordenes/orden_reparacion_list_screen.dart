import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/orden_reparacion.dart';
import '../../providers/orden_reparacion_provider.dart';
import 'orden_reparacion_form_screen.dart';
import 'orden_detalle_screen.dart';

class OrdenReparacionListScreen extends StatefulWidget {
  const OrdenReparacionListScreen({super.key});

  @override
  State<OrdenReparacionListScreen> createState() =>
      _OrdenReparacionListScreenState();
}

class _OrdenReparacionListScreenState extends State<OrdenReparacionListScreen> {
  final _searchController = TextEditingController();
  String? _estadoSeleccionado;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdenReparacionProvider>().cargarOrdenes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    await context.read<OrdenReparacionProvider>().cargarOrdenes(
      search: _searchController.text,
      estado: _estadoSeleccionado,
    );
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'Sin fecha';
    }

    final local = fecha.toLocal();

    String dosDigitos(int value) => value.toString().padLeft(2, '0');

    return '${dosDigitos(local.day)}/'
        '${dosDigitos(local.month)}/'
        '${local.year} '
        '${dosDigitos(local.hour)}:'
        '${dosDigitos(local.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OrdenReparacionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Órdenes de reparación')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const OrdenReparacionFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                labelText: 'Buscar por placa o estado',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _buscar,
                  icon: const Icon(Icons.search),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: DropdownButtonFormField<String?>(
              initialValue: _estadoSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Filtrar por estado',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<String?>(value: null, child: Text('Todos')),
                DropdownMenuItem<String?>(
                  value: 'pendiente',
                  child: Text('Pendiente'),
                ),
                DropdownMenuItem<String?>(
                  value: 'en_proceso',
                  child: Text('En proceso'),
                ),
                DropdownMenuItem<String?>(
                  value: 'finalizado',
                  child: Text('Finalizado'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _estadoSeleccionado = value;
                });

                _buscar();
              },
            ),
          ),
          Expanded(child: _buildContent(provider)),
        ],
      ),
    );
  }

  Widget _buildContent(OrdenReparacionProvider provider) {
    if (provider.isLoading && provider.ordenes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.ordenes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarOrdenes,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.ordenes.isEmpty) {
      return const Center(child: Text('No hay órdenes registradas.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarOrdenes,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: provider.ordenes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final orden = provider.ordenes[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(orden.id?.toString() ?? '?')),
              title: Text(
                'Orden #${orden.id ?? '-'}'
                ' · ${orden.vehiculoPlaca}',
              ),
              subtitle: Text(
                [
                  'Estado: ${orden.estadoVisible}',
                  'Ingreso: ${_formatearFecha(orden.fechaIngreso)}',
                  if (orden.fechaSalida != null)
                    'Salida: ${_formatearFecha(orden.fechaSalida)}',
                  if (orden.observaciones != null &&
                      orden.observaciones!.trim().isNotEmpty)
                    orden.observaciones!,
                ].join('\n'),
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => OrdenDetalleScreen(orden: orden),
                  ),
                );
              },
              trailing: IconButton(
                tooltip: 'Eliminar',
                onPressed: orden.id == null
                    ? null
                    : () => _confirmarEliminar(orden.id!),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmarEliminar(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar orden'),
          content: Text('¿Deseas eliminar la orden #$id?'),
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

    final provider = context.read<OrdenReparacionProvider>();

    final success = await provider.eliminarOrden(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Orden eliminada.'
              : provider.errorMessage ?? 'No se pudo eliminar la orden.',
        ),
      ),
    );
  }
}
