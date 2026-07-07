// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:taller_mecanico_app/main.dart';
import 'package:taller_mecanico_app/domain/model/auth_models.dart';
import 'package:taller_mecanico_app/domain/repository/auth_repository.dart';

// Creamos un repositorio falso rápido para que el test pueda compilar
class FakeAuthRepository implements AuthRepository {
  @override
  Future<LoggedUser> login({
    required String username,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async => {};
  @override
  Future<LoggedUser?> checkAuthStatus() async => null;
}

void main() {
  testWidgets('Verificar inicialización básica del taller', (
    WidgetTester tester,
  ) async {
    // Le pasamos el repositorio falso que ahora nos pide obligatoriamente el constructor
    await tester.pumpWidget(MyApp(authRepository: FakeAuthRepository()));

    // El test pasa si logra compilar e instanciar el árbol de widgets
    expect(true, true);
  });
}
