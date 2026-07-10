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
import 'package:taller_mecanico_app/presentation/providers/cliente_provider.dart';

// Módulo de marcas
import 'package:taller_mecanico_app/domain/repository/marca_repository.dart';
import 'package:taller_mecanico_app/data/repository/marca_repository_impl.dart';
import 'package:taller_mecanico_app/presentation/providers/marca_provider.dart';

// Módulo de vehículos
import 'package:taller_mecanico_app/domain/repository/vehiculo_repository.dart';
import 'package:taller_mecanico_app/data/repository/vehiculo_repository_impl.dart';
import 'package:taller_mecanico_app/presentation/providers/vehiculo_provider.dart';

// Módulo de repuestos
import 'package:taller_mecanico_app/domain/repository/repuesto_repository.dart';
import 'package:taller_mecanico_app/data/repository/repuesto_repository_impl.dart';
import 'package:taller_mecanico_app/presentation/providers/repuesto_provider.dart';

// 🛠️ MÓDULO DE PROVEEDORES INYECTADO:
import 'package:taller_mecanico_app/domain/repository/proveedor_repository.dart';
import 'package:taller_mecanico_app/data/repository/proveedor_repository_impl.dart';
import 'package:taller_mecanico_app/presentation/providers/proveedor_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final secureStorage = SecureStorage();

  final authRepository = AuthRepositoryImpl(
    dioClient: dioClient,
    secureStorage: secureStorage,
  );

  final clienteRepository = ClienteRepositoryImpl(dioClient: dioClient);
  final marcaRepository = MarcaRepositoryImpl(dioClient: dioClient);
  final vehiculoRepository = VehiculoRepositoryImpl(dioClient: dioClient);
  final repuestoRepository = RepuestoRepositoryImpl(dioClient: dioClient);
  final proveedorRepository = ProveedorRepositoryImpl(dioClient: dioClient); // 🛠️ Repositorio instanciado

  runApp(
    MyApp(
      authRepository: authRepository, 
      clienteRepository: clienteRepository,
      marcaRepository: marcaRepository,
      vehiculoRepository: vehiculoRepository,
      repuestoRepository: repuestoRepository,
      proveedorRepository: proveedorRepository, // 🛠️ Pasado a MyApp
    ),
  );
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;
  final ClienteRepository clienteRepository;
  final MarcaRepository marcaRepository;
  final VehiculoRepository vehiculoRepository;
  final RepuestoRepository repuestoRepository;
  final ProveedorRepository proveedorRepository; // 🛠️ Campo añadido

  const MyApp({
    super.key,
    required this.authRepository,
    required this.clienteRepository,
    required this.marcaRepository,
    required this.vehiculoRepository,
    required this.repuestoRepository,
    required this.proveedorRepository, // 🛠️ Requerido en constructor
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;
  late ClienteProvider _clienteProvider; 
  late MarcaProvider _marcaProvider; 
  late VehiculoProvider _vehiculoProvider; 
  late RepuestoProvider _repuestoProvider; 
  late ProveedorProvider _proveedorProvider; // 🛠️ Variable de estado añadida

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(authRepository: widget.authRepository);
    _clienteProvider = ClienteProvider(clienteRepository: widget.clienteRepository);
    _marcaProvider = MarcaProvider(marcaRepository: widget.marcaRepository);
    _vehiculoProvider = VehiculoProvider(vehiculoRepository: widget.vehiculoRepository);
    _repuestoProvider = RepuestoProvider(repuestoRepository: widget.repuestoRepository);
    
    // 🛠️ Inicialización del provider de proveedores
    _proveedorProvider = ProveedorProvider(proveedorRepository: widget.proveedorRepository);

    _authProvider.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    _authProvider.dispose();
    _clienteProvider.dispose(); 
    _marcaProvider.dispose(); 
    _vehiculoProvider.dispose(); 
    _repuestoProvider.dispose(); 
    _proveedorProvider.dispose(); // 🛠️ Limpieza añadida
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _LocalAuthProviderWidget(
      authProvider: _authProvider,
      clienteProvider: _clienteProvider,
      marcaProvider: _marcaProvider, 
      vehiculoProvider: _vehiculoProvider, 
      repuestoProvider: _repuestoProvider, 
      proveedorProvider: _proveedorProvider, // 🛠️ Inyectado en InheritedWidget
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

class _LocalAuthProviderWidget extends InheritedWidget {
  final AuthProvider authProvider;
  final ClienteProvider clienteProvider; 
  final MarcaProvider marcaProvider; 
  final VehiculoProvider vehiculoProvider; 
  final RepuestoProvider repuestoProvider; 
  final ProveedorProvider proveedorProvider; // 🛠️ Campo añadido
  final AuthStatus status;

  _LocalAuthProviderWidget({
    required this.authProvider,
    required this.clienteProvider,
    required this.marcaProvider,
    required this.vehiculoProvider,
    required this.repuestoProvider,
    required this.proveedorProvider, // 🛠️ Requerido en constructor
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
      clienteProvider != oldWidget.clienteProvider ||
      marcaProvider != oldWidget.marcaProvider ||
      vehiculoProvider != oldWidget.vehiculoProvider ||
      repuestoProvider != oldWidget.repuestoProvider ||
      proveedorProvider != oldWidget.proveedorProvider; // 🛠️ Sincronización integrada
}

extension AuthContext on BuildContext {
  AuthProvider get authProvider =>
      _LocalAuthProviderWidget._getInherited(this).authProvider;
      
  ClienteProvider get clienteProvider =>
      _LocalAuthProviderWidget._getInherited(this).clienteProvider;

  MarcaProvider get marcaProvider =>
      _LocalAuthProviderWidget._getInherited(this).marcaProvider;

  VehiculoProvider get vehiculoProvider =>
      _LocalAuthProviderWidget._getInherited(this).vehiculoProvider;

  RepuestoProvider get repuestoProvider =>
      _LocalAuthProviderWidget._getInherited(this).repuestoProvider;

  // 🛠️ Extensión limpia para consumir proveedores con "context.proveedorProvider"
  ProveedorProvider get proveedorProvider =>
      _LocalAuthProviderWidget._getInherited(this).proveedorProvider;
}