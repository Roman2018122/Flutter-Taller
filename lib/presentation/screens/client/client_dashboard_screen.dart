// lib/presentation/screens/client/client_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIS VEHÍCULOS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.accent),
            onPressed: () {
              // TODO: Aquí llamaremos al authProvider.logout()
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_car_filled_rounded,
                size: 72,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Estado de tu Reparación',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aquí aparecerán los autos que tienes ingresados en nuestro taller mecánico.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
