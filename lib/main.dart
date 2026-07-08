// lib/main.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/data/local/secure_storage.dart';
import 'package:taller_mecanico_app/data/repository/auth_repository_impl.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';
import 'package:taller_mecanico_app/domain/repository/auth_repository.dart';
import 'package:taller_mecanico_app/presentation/navigation/app_router.dart';
import 'package:taller_mecanico_app/presentation/providers/auth_provider.dart';
import 'package:taller_mecanico_app/theme/app_theme.dart';

// Módulo de clientes
import 'package:taller_mecanico_app/domain/repository/cliente_repository.dart';
import 'package:taller_mecanico_app/data/repository/cliente_repository_impl.dart';
import 'package:taller_mecanico_app/presentation/providers/cliente_provider.dart'; // 🛠️ Importación añadida

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final secureStorage = SecureStorage();

  final authRepository = AuthRepositoryImpl(
    dioClient: dioClient,
    secureStorage: secureStorage,
  );

  final clienteRepository = ClienteRepositoryImpl(dioClient: dioClient);

  // 🛠️ FIX: Se unificó a una sola llamada pasando ambos repositorios
  runApp(
    MyApp(authRepository: authRepository, clienteRepository: clienteRepository),
  );
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;
  final ClienteRepository clienteRepository; // 🛠️ Añadido campo

  // 🛠️ Constructor actualizado para recibir ambos repositorios obligatoriamente
  const MyApp({
    super.key,
    required this.authRepository,
    required this.clienteRepository,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;
  late ClienteProvider _clienteProvider; // 🛠️ Añadido el provider de clientes

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(authRepository: widget.authRepository);

    // 🛠️ Inicializamos el módulo de clientes usando su respectivo repositorio
    _clienteProvider = ClienteProvider(
      clienteRepository: widget.clienteRepository,
    );

    _authProvider.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _authProvider.dispose();
    _clienteProvider.dispose(); // 🛠️ Limpieza del provider de clientes
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 🚀 Mantenemos tu _LocalAuthProviderWidget. Para que compartamos también el
    // ClienteProvider a las vistas secundarias de forma nativa, lo inyectamos en la extensión de abajo.
    return _LocalAuthProviderWidget(
      authProvider: _authProvider,
      clienteProvider:
          _clienteProvider, // 🛠️ Pasamos el provider al InheritedWidget
      child: MaterialApp(
        key: ValueKey(_authProvider.status),
        title: 'Taller Mecánico App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRouter.getInitialRoute(_authProvider),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

// 📦 InheritedWidget modificado para que exponga ambos Providers con la misma sintaxis limpia
class _LocalAuthProviderWidget extends InheritedWidget {
  final AuthProvider authProvider;
  final ClienteProvider clienteProvider; // 🛠️ Añadido campo
  final AuthStatus status;

  _LocalAuthProviderWidget({
    required this.authProvider,
    required this.clienteProvider, // 🛠️ Requerido en constructor
    required super.child,
  }) : status = authProvider.status;

  static _LocalAuthProviderWidget _getInherited(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_LocalAuthProviderWidget>();
    assert(
      result != null,
      'No se encontró el _LocalAuthProviderWidget en el contexto actual.',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(_LocalAuthProviderWidget oldWidget) =>
      status != oldWidget.status ||
      clienteProvider != oldWidget.clienteProvider;
}

// 📐 Extensiones limpias para que llames a tus Providers desde cualquier parte con context.X
extension AuthContext on BuildContext {
  AuthProvider get authProvider =>
      _LocalAuthProviderWidget._getInherited(this).authProvider;
  // 🛠️ Ahora puedes usar context.clienteProvider en tus vistas de Clientes de forma nativa:
  ClienteProvider get clienteProvider =>
      _LocalAuthProviderWidget._getInherited(this).clienteProvider;
}
