// lib/presentation/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:taller_mecanico_app/theme/app_colors.dart';
import 'package:taller_mecanico_app/main.dart'; // 🛠️ Importante para reconocer "context.authProvider"

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _serverError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _serverError = null;
    });

    // 🚀 CONEXIÓN REAL CON DJANGO:
    // Consumimos el método de login a través de la extensión del InheritedWidget
    final success = await context.authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (!success) {
          // Si Django rechaza las credenciales, capturamos el mensaje de error real
          _serverError = context.authProvider.errorMessage;
        } else {
          // Si es exitoso, el MaterialApp en main.dart reacciona de inmediato al cambio
          // de estado y redirige al Dashboard correspondiente gracias al AppRouter.
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.build_circle_rounded,
                  size: 90,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 16),
                const Text(
                  'SISTEMA DE CONTROL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Text(
                  'Mantenimiento & Reparaciones',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                if (_serverError != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.redAccent.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _serverError!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Ingresa tu nombre de usuario'
                      : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Ingresa tu contraseña'
                      : null,
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.background,
                            ),
                          ),
                        )
                      : const Text('INGRESAR AL TALLER'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
