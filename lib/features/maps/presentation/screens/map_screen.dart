import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/widgets/public_drawer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  // Default center: Surabaya
  final LatLng _center = const LatLng(-7.250445, 112.768845);

  void _moveToCurrentLocation() {
    _mapController.move(_center, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Interaktif'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const PublicDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.respiro',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _center,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.primaryTeal,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildMapInfoCard(),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.my_location_rounded,
                  onTap: _moveToCurrentLocation,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.layers_rounded,
                  onTap: _showLayerBottomSheet,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.tune_rounded,
                  onTap: _showFilterBottomSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kawasan\nSudirman', style: AppTypography.h2),
                  const SizedBox(height: 4),
                  Text('Kec. Setiabudi, Jakarta Selatan', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.coralPale,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: AppColors.coral, size: 16),
                    const SizedBox(width: 4),
                    Text('Risiko\nTinggi', style: AppTypography.caption.copyWith(color: AppColors.coral, fontWeight: FontWeight.bold, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoMetric(
                  icon: Icons.air_rounded,
                  label: 'Kualitas Udara (AQI)',
                  value: '152',
                  status: 'Tidak Sehat',
                  valueColor: AppColors.coral,
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.gray300),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _buildInfoMetric(
                    icon: Icons.thermostat_rounded,
                    label: 'Suhu & Kelembaban',
                    value: '32°C',
                    status: '76%',
                    valueColor: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Rekomendasi Aktivitas', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gray700)),
          const SizedBox(height: 12),
          _buildRecommendationRow(
            icon: Icons.masks_rounded,
            title: 'Gunakan Masker N95',
            desc: 'Sangat disarankan jika harus beraktivitas di luar ruangan.',
          ),
          const SizedBox(height: 12),
          _buildRecommendationRow(
            icon: Icons.home_rounded,
            title: 'Kurangi Aktivitas Outdoor',
            desc: 'Terutama bagi kelompok sensitif (anak-anak, lansia).',
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/facilities'),
              icon: const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 18),
              label: Text('Cari Puskesmas Terdekat', style: AppTypography.button.copyWith(color: AppColors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoMetric({required IconData icon, required String label, required String value, required String status, required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.gray500),
            const SizedBox(width: 4),
            Text(label, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(value, style: AppTypography.h2.copyWith(color: valueColor)),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(status, style: AppTypography.caption.copyWith(color: AppColors.gray700, fontSize: 11)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecommendationRow({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.coral),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gray900)),
              Text(desc, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }

  void _showLayerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Tampilan Peta', style: AppTypography.h2),
              const SizedBox(height: 24),
              _buildBottomSheetOption(icon: Icons.map_rounded, title: 'Peta Standar', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.satellite_alt_rounded, title: 'Satelit', isSelected: false),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.directions_transit_rounded, title: 'Transportasi Umum', isSelected: false),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Tampilan', style: AppTypography.h2),
              const SizedBox(height: 24),
              _buildBottomSheetOption(icon: Icons.air_rounded, title: 'Kualitas Udara (AQI)', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.local_hospital_rounded, title: 'Fasilitas Kesehatan Terdekat', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.thermostat_rounded, title: 'Suhu & Kelembaban', isSelected: false),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({required IconData icon, required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.tealPale : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.gray200),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryTeal : AppColors.gray500),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryTeal : AppColors.gray900,
              ),
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal),
        ],
      ),
    );
  }
}
