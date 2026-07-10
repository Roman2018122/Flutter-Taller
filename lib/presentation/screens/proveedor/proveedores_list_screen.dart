// lib/presentation/screens/proveedor/proveedores_list_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/main.dart'; // Para context.proveedorProvider
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/presentation/screens/proveedor/proveedor_form_screen.dart';

class ProveedoresListScreen extends StatefulWidget {
  const ProveedoresListScreen({super.key});

  @override
  State<ProveedoresListScreen> createState() => _ProveedoresListScreenState();
}

class _ProveedoresListScreenState extends State<ProveedoresListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.proveedorProvider.cargarProveedores();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.proveedorProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PROVEEDORES DEL TALLER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => provider.cargarProveedores(),
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
              : provider.proveedores.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay proveedores registrados.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.proveedores.length,
                      itemBuilder: (context, index) {
                        final proveedor = provider.proveedores[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.accent.withAlpha(40),
                              child: const Icon(Icons.business_rounded, color: AppColors.accent),
                            ),
                            title: Text(
                              proveedor.razonSocial,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('RUC/ID: ${proveedor.ruc}', style: const TextStyle(fontSize: 12)),
                                if (proveedor.telefono != null)
                                  Text('Telf: ${proveedor.telefono}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ProveedorFormScreen(proveedor: proveedor)),
                                );
                              },
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
            MaterialPageRoute(builder: (_) => const ProveedorFormScreen()),
          );
        },
      ),
    );
  }
}