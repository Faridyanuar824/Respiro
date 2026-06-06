import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/features/staff/widgets/custom_bottom_navbar.dart';

class StaffLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StaffLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
