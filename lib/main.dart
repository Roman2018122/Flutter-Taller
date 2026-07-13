import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taller_mecanico_app/presentation/navigation/app_router.dart';

import 'data/local/secure_storage.dart';
import 'data/remote/api/dio_client.dart';
import 'data/repository/auth_repository_impl.dart';
import 'presentation/providers/auth_provider.dart';

//Clientes
import 'data/repository/cliente_repository_impl.dart';
import 'presentation/providers/cliente_provider.dart';
//Vehiculos
import 'data/repository/vehiculo_repository_impl.dart';
import 'presentation/providers/vehiculo_provider.dart';
//servicios
import 'data/repository/servicio_repository_impl.dart';
import 'presentation/providers/servicio_provider.dart';
//especialidades
import 'data/repository/especialidad_repository_impl.dart';
import 'presentation/providers/especialidad_provider.dart';
//mecanico
import 'data/repository/mecanico_repository_impl.dart';
import 'presentation/providers/mecanico_provider.dart';
//Orden reparacion
import 'data/repository/orden_reparacion_repository_impl.dart';
import 'presentation/providers/orden_reparacion_provider.dart';
//detalle servicio
import 'data/repository/detalle_servicio_repository_impl.dart';
import 'presentation/providers/detalle_servicio_provider.dart';

import 'package:go_router/go_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const storage = SecureStorageService();
  final dioClient = DioClient(storage: storage);

  final authRepository = AuthRepositoryImpl(
    dio: dioClient.dio,
    storage: storage,
  );

  final clienteRepository = ClienteRepositoryImpl(dio: dioClient.dio);

  final vehiculoRepository = VehiculoRepositoryImpl(dio: dioClient.dio);

  final servicioRepository = ServicioRepositoryImpl(dio: dioClient.dio);

  final especialidadRepository = EspecialidadRepositoryImpl(dio: dioClient.dio);

  final mecanicoRepository = MecanicoRepositoryImpl(dio: dioClient.dio);

  final ordenReparacionRepository = OrdenReparacionRepositoryImpl(
    dio: dioClient.dio,
  );

  final detalleServicioRepository = DetalleServicioRepositoryImpl(
    dio: dioClient.dio,
  );

  final authProvider = AuthProvider(repository: authRepository);

  await authProvider.initialize();

  final appRouter = AppRouter.createRouter(authProvider: authProvider);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),

        ChangeNotifierProvider<ClienteProvider>(
          create: (_) => ClienteProvider(repository: clienteRepository),
        ),

        ChangeNotifierProvider<VehiculoProvider>(
          create: (_) => VehiculoProvider(repository: vehiculoRepository),
        ),

        ChangeNotifierProvider<ServicioProvider>(
          create: (_) => ServicioProvider(repository: servicioRepository),
        ),

        ChangeNotifierProvider<EspecialidadProvider>(
          create: (_) =>
              EspecialidadProvider(repository: especialidadRepository),
        ),

        ChangeNotifierProvider<MecanicoProvider>(
          create: (_) => MecanicoProvider(repository: mecanicoRepository),
        ),

        ChangeNotifierProvider<OrdenReparacionProvider>(
          create: (_) =>
              OrdenReparacionProvider(repository: ordenReparacionRepository),
        ),

        ChangeNotifierProvider<DetalleServicioProvider>(
          create: (_) =>
              DetalleServicioProvider(repository: detalleServicioRepository),
        ),
      ],
      child: TallerApp(router: appRouter),
    ),
  );
}

class TallerApp extends StatelessWidget {
  final GoRouter router;

  const TallerApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Taller mecánico',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routerConfig: router,
    );
  }
}
