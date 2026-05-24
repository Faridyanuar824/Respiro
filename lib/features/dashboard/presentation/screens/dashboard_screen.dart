import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Respiro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAirQualityCard(),
            const SizedBox(height: 16),
            _buildSelfCheckSummary(),
            const SizedBox(height: 16),
            Text('Rekomendasi Hari Ini', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildRecommendationCard(),
            const SizedBox(height: 16),
            Text('Fasilitas Terdekat', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildNearbyFacilities(),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityCard() {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.tealPale,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.air_rounded,
              color: AppColors.primaryTeal,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kualitas Udara',
                  style: AppTypography.caption.copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Baik - AQI 42',
                  style: AppTypography.h3.copyWith(color: AppColors.green),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.gray300),
        ],
      ),
    );
  }

  Widget _buildSelfCheckSummary() {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.coralPale,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: AppColors.coral,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cek Kesehatan Hari Ini',
                  style: AppTypography.caption.copyWith(color: AppColors.gray500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Belum melakukan cek',
                  style: AppTypography.body.copyWith(color: AppColors.gray700),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.gray300),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return AppCard(
      color: AppColors.tealPale,
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline, color: AppColors.tealDark, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Gunakan masker saat beraktivitas di luar ruangan untuk melindungi saluran pernapasan Anda.',
              style: AppTypography.body.copyWith(color: AppColors.tealDarker),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyFacilities() {
    return Column(
      children: [
        _facilityItem('Puskesmas Kecamatan', '1.2 km', Icons.local_hospital_rounded),
        const SizedBox(height: 8),
        _facilityItem('RS Umum Daerah', '2.5 km', Icons.local_hospital_rounded),
        const SizedBox(height: 8),
        _facilityItem('Klinik Sehat', '0.8 km', Icons.medical_services_rounded),
      ],
    );
  }

  Widget _facilityItem(String name, String distance, IconData icon) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.tealPale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryTeal, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(distance, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gray300),
        ],
      ),
    );
  }
}
