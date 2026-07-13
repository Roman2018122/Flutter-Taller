import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/especialidad_provider.dart';
import 'especialidad_form_screen.dart';

class EspecialidadListScreen extends StatefulWidget {
  const EspecialidadListScreen({super.key});

  @override
  State<EspecialidadListScreen> createState() => _EspecialidadListScreenState();
}

class _EspecialidadListScreenState extends State<EspecialidadListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EspecialidadProvider>().cargarEspecialidades();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    await context.read<EspecialidadProvider>().cargarEspecialidades(
      search: _searchController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EspecialidadProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Especialidades')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const EspecialidadFormScreen()),
          );
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
                labelText: 'Buscar especialidad',
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

  Widget _buildContent(EspecialidadProvider provider) {
    if (provider.isLoading && provider.especialidades.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.especialidades.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarEspecialidades,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.especialidades.isEmpty) {
      return const Center(child: Text('No hay especialidades registradas.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarEspecialidades,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: provider.especialidades.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final especialidad = provider.especialidades[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  especialidad.estaActiva
                      ? Icons.engineering
                      : Icons.engineering_outlined,
                ),
              ),
              title: Text(especialidad.nombre),
              subtitle: Text(
                [
                  if (especialidad.descripcion != null &&
                      especialidad.descripcion!.trim().isNotEmpty)
                    especialidad.descripcion!,
                  especialidad.estaActiva
                      ? 'Estado: Activa'
                      : 'Estado: Inactiva',
                ].join('\n'),
              ),
              isThreeLine:
                  especialidad.descripcion != null &&
                  especialidad.descripcion!.trim().isNotEmpty,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        EspecialidadFormScreen(especialidad: especialidad),
                  ),
                );
              },
              trailing: IconButton(
                tooltip: 'Eliminar',
                onPressed: especialidad.id == null
                    ? null
                    : () => _confirmarEliminar(
                        especialidad.id!,
                        especialidad.nombre,
                      ),
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
          title: const Text('Eliminar especialidad'),
          content: Text('¿Deseas eliminar la especialidad "$nombre"?'),
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

    final provider = context.read<EspecialidadProvider>();

    final success = await provider.eliminarEspecialidad(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Especialidad eliminada.'
              : provider.errorMessage ?? 'No se pudo eliminar la especialidad.',
        ),
      ),
    );
  }
}
