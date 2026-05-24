import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Dashboard'),
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
            _buildStatRow(),
            const SizedBox(height: 16),
            Text('Distribusi Wilayah', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildRegionCard(),
            const SizedBox(height: 16),
            Text('Kasus Terkini', style: AppTypography.h2),
            const SizedBox(height: 12),
            _buildCaseItem('Pasien A', 'Kecamatan Pusat', 'High', AppColors.coral),
            const SizedBox(height: 8),
            _buildCaseItem('Pasien B', 'Kecamatan Utara', 'Medium', AppColors.amber),
            const SizedBox(height: 8),
            _buildCaseItem('Pasien C', 'Kecamatan Selatan', 'Low', AppColors.primaryTeal),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Kasus', '128', AppColors.coral)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Pasien Aktif', '45', AppColors.amber)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Risiko Tinggi', '12', AppColors.coral)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.h1.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildRegionCard() {
    return AppCard(
      child: Column(
        children: [
          _regionRow('Kecamatan Pusat', 42, AppColors.coral),
          const Divider(height: 24),
          _regionRow('Kecamatan Utara', 28, AppColors.amber),
          const Divider(height: 24),
          _regionRow('Kecamatan Selatan', 15, AppColors.primaryTeal),
        ],
      ),
    );
  }

  Widget _regionRow(String name, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: AppTypography.body)),
        Text('$count kasus', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildCaseItem(String name, String region, String risk, Color riskColor) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: riskColor.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              risk,
              style: AppTypography.label.copyWith(color: riskColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                Text(region, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.gray300),
        ],
      ),
    );
  }
}
