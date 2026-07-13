import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//auth
import '../../providers/auth_provider.dart';
//cliente
import '../clientes/cliente_list_screen.dart';
//vehiculo
import '../vehiculos/vehiculo_list_screen.dart';
//servicios
import '../servicios/servicio_list_screen.dart';
//especialidades
import '../especialidades/especialidad_list_screen.dart';
//mecanicos
import '../mecanicos/mecanico_list_screen.dart';
//ordenes
import '../ordenes/orden_reparacion_list_screen.dart';

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
            onPressed: () {
              context.read<AuthProvider>().logout();
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ClienteListScreen()),
              );
            },
          ),
          _DashboardItem(
            icon: Icons.directions_car,
            title: 'Vehículos',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const VehiculoListScreen()),
              );
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ServicioListScreen()),
              );
            },
            //especialidades
          ),
          _DashboardItem(
            icon: Icons.handyman,
            title: 'Especialidades',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const EspecialidadListScreen(),
                ),
              );
            },
          ),
          _DashboardItem(
            icon: Icons.engineering,
            title: 'Mecánicos',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MecanicoListScreen()),
              );
            },
          ),
          _DashboardItem(
            icon: Icons.receipt_long,
            title: 'Órdenes',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const OrdenReparacionListScreen(),
                ),
              );
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
