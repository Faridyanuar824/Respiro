import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peta Interaktif')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_rounded, size: 64, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  'Peta akan ditampilkan di sini',
                  style: AppTypography.body.copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Integrasi Leaflet/OSM dengan flutter_map',
                  style: AppTypography.caption.copyWith(color: AppColors.gray300),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _buildFilterButton(Icons.my_location_rounded),
                const SizedBox(height: 8),
                _buildFilterButton(Icons.layers_rounded),
                const SizedBox(height: 8),
                _buildFilterButton(Icons.tune_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.primaryTeal, size: 20),
    );
  }
}
