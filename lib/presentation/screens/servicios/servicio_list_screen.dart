import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/servicio_provider.dart';
import 'servicio_form_screen.dart';

class ServicioListScreen extends StatefulWidget {
  const ServicioListScreen({super.key});

  @override
  State<ServicioListScreen> createState() => _ServicioListScreenState();
}

class _ServicioListScreenState extends State<ServicioListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicioProvider>().cargarServicios();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    await context.read<ServicioProvider>().cargarServicios(
      search: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServicioProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const ServicioFormScreen()));
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
                labelText: 'Buscar servicio',
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

  Widget _buildContent(ServicioProvider provider) {
    if (provider.isLoading && provider.servicios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.servicios.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarServicios,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.servicios.isEmpty) {
      return const Center(child: Text('No hay servicios registrados.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarServicios,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: provider.servicios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final servicio = provider.servicios[index];

          return Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.build)),
              title: Text(servicio.nombre),
              subtitle: Text(
                [
                  if (servicio.descripcion != null &&
                      servicio.descripcion!.trim().isNotEmpty)
                    servicio.descripcion!,
                  'Precio referencial: \$${servicio.precioReferencial.toStringAsFixed(2)}',
                ].join('\n'),
              ),
              isThreeLine:
                  servicio.descripcion != null &&
                  servicio.descripcion!.trim().isNotEmpty,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ServicioFormScreen(servicio: servicio),
                  ),
                );
              },
              trailing: IconButton(
                tooltip: 'Eliminar',
                onPressed: servicio.id == null
                    ? null
                    : () => _confirmarEliminar(servicio.id!, servicio.nombre),
                icon: const Icon(Icons.delete_outline),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmarEliminar(int id, String nombre) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar servicio'),
          content: Text('¿Deseas eliminar el servicio "$nombre"?'),
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

    final provider = context.read<ServicioProvider>();
    final success = await provider.eliminarServicio(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Servicio eliminado.'
              : provider.errorMessage ?? 'No se pudo eliminar el servicio.',
        ),
      ),
    );
  }
}
