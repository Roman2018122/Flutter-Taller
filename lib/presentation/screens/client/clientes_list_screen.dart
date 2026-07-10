// lib/presentation/screens/client/clientes_list_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/main.dart'; // Importante para context.clienteProvider
import 'package:taller_mecanico_app/domain/model/cliente_model.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/presentation/screens/client/cliente_form_screen.dart';

class ClientesListScreen extends StatefulWidget {
  const ClientesListScreen({super.key});

  @override
  State<ClientesListScreen> createState() => _ClientesListScreenState();
}

class _ClientesListScreenState extends State<ClientesListScreen> {
  @override
  void initState() {
    super.initState();
    // Solicitamos la lista de clientes a Django inmediatamente al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.clienteProvider.cargarClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.clienteProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GESTIÓN DE CLIENTES'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.cargarClientes(),
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
              : provider.clientes.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay clientes registrados en el sistema.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.clientes.length,
                      itemBuilder: (context, index) {
                        final cliente = provider.clientes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.accent,
                              child: Icon(Icons.person, color: Colors.black),
                            ),
                            title: Text(
                              cliente.nombreCompleto.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('C.I.: ${cliente.cedulaIdentidad}'),
                                if (cliente.telefono != null) Text('Tel: ${cliente.telefono}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 🛠️ ENLACE DE EDICIÓN CONFIGURADO:
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ClienteFormScreen(cliente: cliente),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmarEliminacion(context, cliente),
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
            MaterialPageRoute(builder: (_) => const ClienteFormScreen()),
          );
        },
      ), // 🛠️ FIX: Se añadió el cierre correcto del botón
    );
  }

  void _confirmarEliminacion(BuildContext context, Cliente cliente) {
    if (cliente.id == null) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar Cliente?'),
        content: Text('Esta acción eliminará a ${cliente.nombreCompleto} de forma permanente del sistema.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await context.clienteProvider.removerCliente(cliente.id!);
              if (mounted && success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cliente eliminado con éxito.')),
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