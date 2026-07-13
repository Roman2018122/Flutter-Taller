import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PublicContactScreen extends StatelessWidget {
  const PublicContactScreen({super.key});

  static const String telefono = '0999999999';
  static const String correo = 'taller@example.com';
  static const String direccion = 'Dirección del taller, Ecuador';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(
          Icons.contact_phone_outlined,
          size: 74,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Contáctanos',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        const Text(
          'Comunícate con nosotros para consultar disponibilidad, precios o información sobre nuestros servicios.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        _ContactCard(
          icon: Icons.phone,
          title: 'Teléfono',
          value: telefono,
          onCopy: () {
            _copyValue(context, telefono, 'Teléfono copiado.');
          },
        ),
        _ContactCard(
          icon: Icons.email_outlined,
          title: 'Correo electrónico',
          value: correo,
          onCopy: () {
            _copyValue(context, correo, 'Correo copiado.');
          },
        ),
        _ContactCard(
          icon: Icons.location_on_outlined,
          title: 'Dirección',
          value: direccion,
          onCopy: () {
            _copyValue(context, direccion, 'Dirección copiada.');
          },
        ),
        const SizedBox(height: 18),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.schedule, size: 38),
                SizedBox(height: 12),
                Text(
                  'Horario',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('Lunes a viernes: 08:00 - 18:00'),
                SizedBox(height: 6),
                Text('Sábado: 08:00 - 13:00'),
                SizedBox(height: 6),
                Text('Domingo: cerrado'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> _copyValue(
    BuildContext context,
    String value,
    String message,
  ) async {
    await Clipboard.setData(ClipboardData(text: value));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onCopy;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(value),
        trailing: IconButton(
          tooltip: 'Copiar',
          onPressed: onCopy,
          icon: const Icon(Icons.copy),
        ),
      ),
    );
  }
}
