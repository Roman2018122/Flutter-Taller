// lib/presentation/screens/dashboard/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/main.dart'; 
import 'package:taller_mecanico_app/presentation/screens/client/clientes_list_screen.dart'; 
import 'package:taller_mecanico_app/presentation/screens/marca/marcas_list_screen.dart'; 
import 'package:taller_mecanico_app/presentation/screens/repuesto/repuestos_list_screen.dart';
import 'package:taller_mecanico_app/presentation/screens/proveedor/proveedores_list_screen.dart'; // ✅ Importación de proveedores

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PANEL TALLER MECÁNICO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.accent),
            onPressed: () {
              context.authProvider.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estadísticas Operativas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              // Tarjeta para órdenes activas
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.build_circle_rounded,
                    color: AppColors.accent,
                    size: 40,
                  ),
                  title: Text(
                    'Vehículos en Elevador',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Hay 4 órdenes en proceso de reparación actualmente.',
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 12), 

              // 🚀 ACCESO A CLIENTES:
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientesListScreen()),
                    );
                  },
                  leading: const Icon(
                    Icons.people_alt_rounded,
                    color: AppColors.accent,
                    size: 40,
                  ),
                  title: const Text(
                    'Gestión de Clientes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Ver el listado de clientes, buscar por cédula o registrar nuevos.',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 12), 

              // 🚀 ACCESO A MARCAS:
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MarcasListScreen()),
                    );
                  },
                  leading: const Icon(
                    Icons.time_to_leave_rounded, 
                    color: AppColors.accent,
                    size: 40,
                  ),
                  title: const Text(
                    'Marcas de Vehículos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Configurar fabricantes y marcas del taller (Toyota, Chevrolet, etc.).',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🚀 ACCESO A PROVEEDORES (NUEVO):
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProveedoresListScreen()),
                    );
                  },
                  leading: const Icon(
                    Icons.business_rounded, 
                    color: AppColors.accent,
                    size: 40,
                  ),
                  title: const Text(
                    'Proveedores Comerciales',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Administrar casas comerciales, números de RUC y datos de contacto.',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🚀 ACCESO A INVENTARIO DE REPUESTOS:
              Card(
                color: AppColors.surface,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RepuestosListScreen()),
                    );
                  },
                  leading: const Icon(
                    Icons.inventory_rounded, 
                    color: AppColors.accent,
                    size: 40,
                  ),
                  title: const Text(
                    'Inventario de Repuestos',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text(
                    'Controlar existencias, agregar refacciones y ajustar precios de venta.',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}