// lib/presentation/screens/repuesto/repuestos_list_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/main.dart'; // Para context.repuestoProvider
import 'package:taller_mecanico_app/domain/model/repuesto_model.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/presentation/screens/repuesto/repuesto_form_screen.dart';

class RepuestosListScreen extends StatefulWidget {
  const RepuestosListScreen({super.key});

  @override
  State<RepuestosListScreen> createState() => _RepuestosListScreenState();
}

class _RepuestosListScreenState extends State<RepuestosListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.repuestoProvider.cargarRepuestos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.repuestoProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('INVENTARIO DE REPUESTOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => provider.cargarRepuestos(),
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
              : provider.repuestos.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay repuestos en inventario.',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: provider.repuestos.length,
                      itemBuilder: (context, index) {
                        final repuesto = provider.repuestos[index];
                        final bajoStock = repuesto.stockActual <= repuesto.stockMinimo;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: bajoStock ? Colors.red.withAlpha(50) : AppColors.accent.withAlpha(40),
                              child: Icon(
                                Icons.precision_manufacturing_rounded, 
                                color: bajoStock ? Colors.red : AppColors.accent
                              ),
                            ),
                            title: Text(
                              repuesto.nombre.toUpperCase(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Código/SKU: ${repuesto.codigo}', style: const TextStyle(fontSize: 12)),
                                Text(
                                  'Precio Venta: \$${repuesto.precioVenta.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Badge indicador de Stock
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: bajoStock ? Colors.red : Colors.grey[800],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Cant: ${repuesto.stockActual}',
                                    style: TextStyle(
                                      color: bajoStock ? Colors.white : AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => RepuestoFormScreen(repuesto: repuesto)),
                                    );
                                  },
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
            MaterialPageRoute(builder: (_) => const RepuestoFormScreen()),
          );
        },
      ),
    );
  }
}