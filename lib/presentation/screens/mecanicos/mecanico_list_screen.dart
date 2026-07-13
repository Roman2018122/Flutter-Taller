import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/mecanico.dart';
import '../../providers/especialidad_provider.dart';
import '../../providers/mecanico_provider.dart';
import 'mecanico_form_screen.dart';

class MecanicoListScreen extends StatefulWidget {
  const MecanicoListScreen({super.key});

  @override
  State<MecanicoListScreen> createState() => _MecanicoListScreenState();
}

class _MecanicoListScreenState extends State<MecanicoListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        context.read<MecanicoProvider>().cargarMecanicos(),
        context.read<EspecialidadProvider>().cargarEspecialidades(),
      ]);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    await context.read<MecanicoProvider>().cargarMecanicos(
      search: _searchController.text,
    );
  }

  String _obtenerEspecialidades(BuildContext context, Mecanico mecanico) {
    final especialidades = context.read<EspecialidadProvider>().especialidades;

    final nombres = especialidades
        .where(
          (item) =>
              item.id != null && mecanico.especialidadesIds.contains(item.id),
        )
        .map((item) => item.nombre)
        .toList();

    if (nombres.isEmpty) {
      return 'Sin especialidades asignadas';
    }

    return nombres.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MecanicoProvider>();

    // Permite reconstruir la lista cuando carguen las especialidades.
    context.watch<EspecialidadProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mecánicos')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MecanicoFormScreen()));
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
                labelText: 'Buscar por nombre o estado',
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

  Widget _buildContent(MecanicoProvider provider) {
    if (provider.isLoading && provider.mecanicos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null && provider.mecanicos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: provider.cargarMecanicos,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.mecanicos.isEmpty) {
      return const Center(child: Text('No hay mecánicos registrados.'));
    }

    return RefreshIndicator(
      onRefresh: provider.cargarMecanicos,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        itemCount: provider.mecanicos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final mecanico = provider.mecanicos[index];

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  mecanico.estaActivo
                      ? Icons.engineering
                      : Icons.person_off_outlined,
                ),
              ),
              title: Text(mecanico.nombre),
              subtitle: Text(
                [
                  if (mecanico.telefono != null &&
                      mecanico.telefono!.trim().isNotEmpty)
                    'Teléfono: ${mecanico.telefono}',
                  'Estado: ${mecanico.estaActivo ? 'Activo' : 'Inactivo'}',
                  'Especialidades: ${_obtenerEspecialidades(context, mecanico)}',
                ].join('\n'),
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MecanicoFormScreen(mecanico: mecanico),
                  ),
                );
              },
              trailing: IconButton(
                tooltip: 'Eliminar',
                onPressed: mecanico.id == null
                    ? null
                    : () => _confirmarEliminar(mecanico.id!, mecanico.nombre),
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
          title: const Text('Eliminar mecánico'),
          content: Text('¿Deseas eliminar al mecánico "$nombre"?'),
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

    final provider = context.read<MecanicoProvider>();
    final success = await provider.eliminarMecanico(id);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Mecánico eliminado.'
              : provider.errorMessage ?? 'No se pudo eliminar el mecánico.',
        ),
      ),
    );
  }
}
