import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaffLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StaffLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Pasien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: 'GIS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
