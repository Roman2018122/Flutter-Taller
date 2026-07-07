// lib/presentation/screens/dashboard/admin_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';

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
              // TODO: Aquí llamaremos al authProvider.logout()
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas Operativas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Tarjeta de ejemplo para órdenes activas
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
          ],
        ),
      ),
    );
  }
}
