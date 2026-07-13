import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//auth
import '../../providers/auth_provider.dart';
//
import 'package:go_router/go_router.dart';
import '../../navigation/app_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administración'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              await context.read<AuthProvider>().logout();

              if (!context.mounted) {
                return;
              }

              context.go(AppRoutes.publicHome);
            },

            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _DashboardItem(
            icon: Icons.people,
            title: 'Clientes',
            onTap: () {
              context.push(AppRoutes.clientes);
            },
          ),
          _DashboardItem(
            icon: Icons.directions_car,
            title: 'Vehículos',
            onTap: () {
              context.push(AppRoutes.vehiculos);
            },
          ),
          _DashboardItem(
            icon: Icons.calendar_month,
            title: 'Citas',
            onTap: () {},
          ),
          _DashboardItem(
            icon: Icons.build,
            title: 'Servicios',
            onTap: () {
              context.push(AppRoutes.serviciosAdmin);
            },
            //especialidades
          ),
          _DashboardItem(
            icon: Icons.handyman,
            title: 'Especialidades',
            onTap: () {
              context.push(AppRoutes.especialidades);
            },
          ),
          _DashboardItem(
            icon: Icons.engineering,
            title: 'Mecánicos',
            onTap: () {
              context.push(AppRoutes.mecanicos);
            },
          ),
          _DashboardItem(
            icon: Icons.receipt_long,
            title: 'Órdenes',
            onTap: () {
              context.push(AppRoutes.ordenes);
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 44),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
