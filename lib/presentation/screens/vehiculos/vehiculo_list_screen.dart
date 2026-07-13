import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/vehiculo_provider.dart';
import 'vehiculo_form_screen.dart';

class VehiculoListScreen extends StatefulWidget {
  const VehiculoListScreen({super.key});

  @override
  State<VehiculoListScreen> createState() => _VehiculoListScreenState();
}

class _VehiculoListScreenState extends State<VehiculoListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehiculoProvider>().cargarVehiculos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    await context.read<VehiculoProvider>().cargarVehiculos(
      search: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehiculoProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Vehículos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VehiculoFormScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                labelText: 'Buscar por placa, cliente o modelo',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: _buscar,
                  icon: const Icon(Icons.search),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildContent(provider)),
        ],
      ),
    );
  }

  Widget _buildContent(VehiculoProvider provider) {
    if (provider.isLoading && provider.vehiculos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.vehiculos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarVehiculos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.vehiculos.isEmpty) {
      return const Center(child: Text('No hay vehículos registrados.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarVehiculos,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: provider.vehiculos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final vehiculo = provider.vehiculos[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.directions_car)),
              title: Text(vehiculo.placa),
              subtitle: Text(
                '${vehiculo.descripcionModelo}\n'
                'Año: ${vehiculo.anio}\n'
                'Cliente: ${vehiculo.clienteNombre}',
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehiculoFormScreen(vehiculo: vehiculo),
                  ),
                );
              },
              trailing: IconButton(
                tooltip: 'Eliminar',
                onPressed: vehiculo.id == null
                    ? null
                    : () => _confirmarEliminar(vehiculo.id!, vehiculo.placa),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmarEliminar(int id, String placa) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar vehículo'),
          content: Text('¿Deseas eliminar el vehículo con placa $placa?'),
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

    final provider = context.read<VehiculoProvider>();
    final success = await provider.eliminarVehiculo(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Vehículo eliminado.'
              : provider.errorMessage ?? 'No se pudo eliminar el vehículo.',
        ),
      ),
    );
  }
}
