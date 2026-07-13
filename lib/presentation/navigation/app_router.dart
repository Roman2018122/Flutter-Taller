import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/clientes/cliente_list_screen.dart';
import '../screens/dashboard/admin_dashboard_screen.dart';
import '../screens/especialidades/especialidad_list_screen.dart';
import '../screens/mecanicos/mecanico_list_screen.dart';
import '../screens/ordenes/orden_reparacion_list_screen.dart';
import '../screens/public/public_shell_screen.dart';
import '../screens/servicios/servicio_list_screen.dart';
import '../screens/vehiculos/vehiculo_list_screen.dart';

import '../screens/auth/register_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const publicHome = '/';
  static const publicServices = '/servicios';
  static const publicContact = '/contacto';
  static const login = '/login';
  static const register = '/registro';

  static const admin = '/admin';
  static const clientes = '/admin/clientes';
  static const vehiculos = '/admin/vehiculos';
  static const serviciosAdmin = '/admin/servicios';
  static const especialidades = '/admin/especialidades';
  static const mecanicos = '/admin/mecanicos';
  static const ordenes = '/admin/ordenes';
}

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({required AuthProvider authProvider}) {
    return GoRouter(
      initialLocation: AppRoutes.publicHome,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final status = authProvider.status;

        final currentPath = state.matchedLocation;
        final isAdminRoute = currentPath.startsWith('/admin');
        final isAuthRoute =
            currentPath == AppRoutes.login || currentPath == AppRoutes.register;

        if (status == AuthStatus.checking) {
          return null;
        }

        if (status == AuthStatus.unauthenticated && isAdminRoute) {
          return AppRoutes.login;
        }

        if (status == AuthStatus.authenticated && isAuthRoute) {
          return AppRoutes.admin;
        }

        return null;
      },
      errorBuilder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Página no encontrada')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No existe la ruta ${state.uri.path}.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      context.go(AppRoutes.publicHome);
                    },
                    child: const Text('Volver al inicio'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.publicHome,
          builder: (context, state) {
            return const PublicShellScreen(initialIndex: 0);
          },
        ),
        GoRoute(
          path: AppRoutes.publicServices,
          builder: (context, state) {
            return const PublicShellScreen(initialIndex: 1);
          },
        ),
        GoRoute(
          path: AppRoutes.publicContact,
          builder: (context, state) {
            return const PublicShellScreen(initialIndex: 2);
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) {
            return const LoginScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) {
            return const RegisterScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.admin,
          builder: (context, state) {
            return const AdminDashboardScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.clientes,
          builder: (context, state) {
            return const ClienteListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.vehiculos,
          builder: (context, state) {
            return const VehiculoListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.serviciosAdmin,
          builder: (context, state) {
            return const ServicioListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.especialidades,
          builder: (context, state) {
            return const EspecialidadListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.mecanicos,
          builder: (context, state) {
            return const MecanicoListScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.ordenes,
          builder: (context, state) {
            return const OrdenReparacionListScreen();
          },
        ),
      ],
    );
  }
}
