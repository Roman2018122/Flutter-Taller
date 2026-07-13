import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/register_request.dart';
import '../../navigation/app_router.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmacionController = TextEditingController();

  bool _ocultarPassword = true;
  bool _ocultarConfirmacion = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _passwordController.dispose();
    _passwordConfirmacionController.dispose();
    super.dispose();
  }

  Future<void> _registrar() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final request = RegisterRequest(
      username: _usernameController.text.trim(),
      password: _passwordController.text,
      passwordConfirmacion: _passwordConfirmacionController.text,
      nombre: _nombreController.text.trim(),
      telefono: _telefonoController.text.trim(),
      correo: _correoController.text.trim(),
      direccion: _direccionController.text.trim(),
    );

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.register(request);

    if (!mounted) {
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cuenta creada correctamente. Ya puedes iniciar sesión.',
          ),
        ),
      );

      context.go(AppRoutes.login);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          authProvider.errorMessage ?? 'No se pudo crear la cuenta.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        leading: IconButton(
          tooltip: 'Volver',
          onPressed: isLoading
              ? null
              : () {
                  context.go(AppRoutes.publicHome);
                },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.person_add_alt_1, size: 78),
                    const SizedBox(height: 16),
                    Text(
                      'Registro de cliente',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Crea tu cuenta para registrar vehículos, solicitar citas y consultar reparaciones.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 28),

                    TextFormField(
                      controller: _usernameController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final username = value?.trim() ?? '';

                        if (username.isEmpty) {
                          return 'Ingresa un nombre de usuario.';
                        }

                        if (username.length < 4) {
                          return 'El usuario debe tener al menos 4 caracteres.';
                        }

                        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
                          return 'Usa solo letras, números y guion bajo.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _nombreController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final nombre = value?.trim() ?? '';

                        if (nombre.isEmpty) {
                          return 'Ingresa tu nombre completo.';
                        }

                        if (nombre.length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _correoController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final correo = value?.trim() ?? '';

                        if (correo.isEmpty) {
                          return 'Ingresa tu correo electrónico.';
                        }

                        final correoValido = RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(correo);

                        if (!correoValido) {
                          return 'Ingresa un correo válido.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _telefonoController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(15),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final telefono = value?.trim() ?? '';

                        if (telefono.isEmpty) {
                          return 'Ingresa tu número de teléfono.';
                        }

                        if (telefono.length < 7) {
                          return 'El teléfono es demasiado corto.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _direccionController,
                      enabled: !isLoading,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 2,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final direccion = value?.trim() ?? '';

                        if (direccion.isEmpty) {
                          return 'Ingresa tu dirección.';
                        }

                        if (direccion.length < 5) {
                          return 'La dirección es demasiado corta.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordController,
                      enabled: !isLoading,
                      obscureText: _ocultarPassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _ocultarPassword
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: () {
                            setState(() {
                              _ocultarPassword = !_ocultarPassword;
                            });
                          },
                          icon: Icon(
                            _ocultarPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';

                        if (password.isEmpty) {
                          return 'Ingresa una contraseña.';
                        }

                        if (password.length < 8) {
                          return 'La contraseña debe tener al menos 8 caracteres.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _passwordConfirmacionController,
                      enabled: !isLoading,
                      obscureText: _ocultarConfirmacion,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        if (!isLoading) {
                          _registrar();
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Confirmar contraseña',
                        prefixIcon: const Icon(Icons.lock_reset),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: _ocultarConfirmacion
                              ? 'Mostrar contraseña'
                              : 'Ocultar contraseña',
                          onPressed: () {
                            setState(() {
                              _ocultarConfirmacion = !_ocultarConfirmacion;
                            });
                          },
                          icon: Icon(
                            _ocultarConfirmacion
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirma tu contraseña.';
                        }

                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden.';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    FilledButton.icon(
                      onPressed: isLoading ? null : _registrar,
                      icon: isLoading
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.person_add),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          isLoading ? 'Creando cuenta...' : 'Crear cuenta',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.go(AppRoutes.login);
                            },
                      child: const Text(
                        '¿Ya tienes una cuenta? Iniciar sesión',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
