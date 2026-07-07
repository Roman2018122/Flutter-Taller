// lib/main.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/data/local/secure_storage.dart';
import 'package:taller_mecanico_app/data/repository/auth_repository_impl.dart';
import 'package:taller_mecanico_app/data/remote/api/dio_client.dart';
import 'package:taller_mecanico_app/domain/repository/auth_repository.dart';
import 'package:taller_mecanico_app/presentation/navigation/app_router.dart';
import 'package:taller_mecanico_app/presentation/providers/auth_provider.dart';
import 'package:taller_mecanico_app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();
  final secureStorage = SecureStorage();

  final authRepository = AuthRepositoryImpl(
    dioClient: dioClient,
    secureStorage: secureStorage,
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatefulWidget {
  final AuthRepository authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = AuthProvider(authRepository: widget.authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return _LocalAuthProviderWidget(
      authProvider: _authProvider,
      child: MaterialApp(
        title: 'Taller Mecánico App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,

        // 🛠️ FIX: Entramos directo al Login para asegurar que la pantalla pinte de inmediato
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

class _LocalAuthProviderWidget extends InheritedWidget {
  final AuthProvider authProvider;
  const _LocalAuthProviderWidget({
    required this.authProvider,
    required super.child,
  });

  static AuthProvider of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_LocalAuthProviderWidget>();
    assert(result != null, 'No se encontró el AuthProvider');
    return result!.authProvider;
  }

  @override
  bool updateShouldNotify(_LocalAuthProviderWidget oldWidget) =>
      authProvider != oldWidget.authProvider;
}

extension AuthContext on BuildContext {
  AuthProvider get authProvider => _LocalAuthProviderWidget.of(this);
}
