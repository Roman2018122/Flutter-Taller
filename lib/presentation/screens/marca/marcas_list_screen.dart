// lib/presentation/screens/marca/marcas_list_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/main.dart'; // Para context.marcaProvider
import 'package:taller_mecanico_app/domain/model/marca_model.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/presentation/screens/marca/marca_form_screen.dart';

class MarcasListScreen extends StatefulWidget {
  const MarcasListScreen({super.key});

  @override
  State<MarcasListScreen> createState() => _MarcasListScreenState();
}

class _MarcasListScreenState extends State<MarcasListScreen> {
  @override
  void initState() {
    super.initState();
    // Solicita las marcas a Django al entrar a la vista
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.marcaProvider.cargarMarcas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.marcaProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MARCAS DE VEHÍCULOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.cargarMarcas(),
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${provider.errorMessage}',
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : provider.marcas.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay marcas registradas.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.marcas.length,
                      itemBuilder: (context, index) {
                        final marca = provider.marcas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.accent,
                              child: Icon(Icons.time_to_leave_rounded, color: Colors.black),
                            ),
                            title: Text(
                              marca.nombre.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                            subtitle: marca.descripcion != null && marca.descripcion!.isNotEmpty
                                ? Text(marca.descripcion!)
                                : const Text('Sin descripción', style: TextStyle(fontStyle: FontStyle.italic)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => MarcaFormScreen(marca: marca)),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmarEliminacion(context, marca),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MarcaFormScreen()),
          );
        },
      ),
    );
  }

  void _confirmarEliminacion(BuildContext context, Marca marca) {
    if (marca.id == null) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar Marca?'),
        content: Text('Esto afectará a los vehículos vinculados a la marca ${marca.nombre.toUpperCase()}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await context.marcaProvider.removerMarca(marca.id!);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Marca eliminada con éxito.')),
                );
              }
            },
            child: const Text('ELIMINAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}