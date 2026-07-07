// lib/presentation/navigation/app_router.dart

import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

// Importaciones de tus pantallas (las crearemos a continuación)
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/admin_dashboard_screen.dart';
import '../screens/client/client_dashboard_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String adminDashboard = '/admin-dashboard';
  static const String clientDashboard = '/client-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
      case clientDashboard:
        return MaterialPageRoute(builder: (_) => const ClientDashboardScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Ruta no definida: ${settings.name}')),
          ),
        );
    }
  }

  // ── Guardián de Navegación (Redirección Automática) ────────────────
  static String getInitialRoute(AuthProvider authProvider) {
    switch (authProvider.status) {
      case AuthStatus.checking:
        return splash;
      case AuthStatus.unauthenticated:
        return login;
      case AuthStatus.authenticated:
        // Aquí decidimos a dónde va según su ROL de Django
        final user = authProvider.currentUser;
        if (user != null &&
            (user.rol == 'ADMIN' || user.rol == 'MECANICO' || user.isStaff)) {
          return adminDashboard;
        } else {
          return clientDashboard;
        }
    }
  }
}
