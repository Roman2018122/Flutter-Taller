import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/servicio_provider.dart';

class PublicServicesScreen extends StatefulWidget {
  const PublicServicesScreen({super.key});

  @override
  State<PublicServicesScreen> createState() => _PublicServicesScreenState();
}

class _PublicServicesScreenState extends State<PublicServicesScreen> {
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

  Future<void> _buscar() {
    return context.read<ServicioProvider>().cargarServicios(
      search: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServicioProvider>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _buscar(),
            decoration: InputDecoration(
              labelText: 'Buscar servicio',
              hintText: 'Ejemplo: aceite, frenos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Buscar',
                onPressed: _buscar,
                icon: const Icon(Icons.search),
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(child: _buildContent(provider)),
      ],
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
              const Icon(Icons.cloud_off, size: 54),
              const SizedBox(height: 16),
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: provider.cargarServicios,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.servicios.isEmpty) {
      return const Center(child: Text('No hay servicios disponibles.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarServicios,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: provider.servicios.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final servicio = provider.servicios[index];

          final descripcion = servicio.descripcion?.trim() ?? '';

          return Card(
            child: ExpansionTile(
              leading: const CircleAvatar(child: Icon(Icons.build_outlined)),
              title: Text(
                servicio.nombre,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Desde \$${servicio.precioReferencial.toStringAsFixed(2)}',
              ),
              childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    descripcion.isEmpty
                        ? 'Consulta con el taller para conocer los detalles de este servicio.'
                        : descripcion,
                  ),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'El precio es referencial y puede variar según el diagnóstico y las condiciones del vehículo.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
