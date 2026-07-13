import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_router.dart';
import 'public_contact_screen.dart';
import 'public_home_screen.dart';
import 'public_services_screen.dart';

class PublicShellScreen extends StatefulWidget {
  final int initialIndex;

  const PublicShellScreen({super.key, this.initialIndex = 0});

  @override
  State<PublicShellScreen> createState() => _PublicShellScreenState();
}

class _PublicShellScreenState extends State<PublicShellScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant PublicShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      _selectedIndex = widget.initialIndex;
    }
  }

  void _openSection(int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.publicHome);
        break;
      case 1:
        context.go(AppRoutes.publicServices);
        break;
      case 2:
        context.go(AppRoutes.publicContact);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      PublicHomeScreen(
        onOpenServices: () {
          context.go(AppRoutes.publicServices);
        },
        onOpenLogin: () {
          context.go(AppRoutes.login);
        },
      ),
      const PublicServicesScreen(),
      const PublicContactScreen(),
    ];

    const titles = ['Taller Mecánico', 'Nuestros servicios', 'Contacto'];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_selectedIndex])),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _openSection,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined),
            selectedIcon: Icon(Icons.build),
            label: 'Servicios',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_phone_outlined),
            selectedIcon: Icon(Icons.contact_phone),
            label: 'Contacto',
          ),
        ],
      ),
    );
  }
}
