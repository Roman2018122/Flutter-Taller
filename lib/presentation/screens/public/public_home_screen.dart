import 'package:flutter/material.dart';

class PublicHomeScreen extends StatelessWidget {
  final VoidCallback onOpenServices;
  final VoidCallback onOpenLogin;

  const PublicHomeScreen({
    super.key,
    required this.onOpenServices,
    required this.onOpenLogin,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHero(context),
        const SizedBox(height: 24),
        _buildIntroduction(context),
        const SizedBox(height: 24),
        _buildBenefits(context),
        const SizedBox(height: 24),
        _buildSchedule(context),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 42, 24, 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.car_repair, size: 88, color: colorScheme.onPrimary),
          const SizedBox(height: 20),
          Text(
            'Taller Mecánico Torres',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Mantenimiento, diagnóstico y reparación para mantener tu vehículo en las mejores condiciones.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: colorScheme.onPrimary),
          ),
          const SizedBox(height: 26),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                onPressed: onOpenServices,
                icon: const Icon(Icons.build),
                label: const Text('Ver servicios'),
              ),
              OutlinedButton.icon(
                onPressed: onOpenLogin,
                icon: const Icon(Icons.login),
                label: const Text('Administración'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.onPrimary,
                  side: BorderSide(color: colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                Icons.handyman,
                size: 44,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 14),
              Text(
                'Atención confiable para tu vehículo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'Gestionamos cada vehículo mediante órdenes de reparación, servicios asignados y seguimiento del estado del mantenimiento.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefits(BuildContext context) {
    const benefits = [
      (
        Icons.fact_check_outlined,
        'Diagnóstico',
        'Registro detallado de las necesidades del vehículo.',
      ),
      (
        Icons.engineering_outlined,
        'Personal técnico',
        'Servicios asignados a mecánicos especializados.',
      ),
      (
        Icons.history_outlined,
        'Seguimiento',
        'Control del estado y del historial de las reparaciones.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            '¿Por qué elegirnos?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          ...benefits.map(
            (benefit) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Icon(benefit.$1)),
                title: Text(benefit.$2),
                subtitle: Text(benefit.$3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchedule(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'Horario de atención',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Lunes a viernes'), Text('08:00 - 18:00')],
              ),
              const Divider(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Sábado'), Text('08:00 - 13:00')],
              ),
              const Divider(),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Domingo'), Text('Cerrado')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
