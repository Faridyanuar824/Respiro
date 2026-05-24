import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Kesehatan')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        children: [
          _buildDateHeader('Hari Ini'),
          const SizedBox(height: 8),
          _buildHistoryItem(
            'Cek Kesehatan',
            'Suhu: 36.5°C • Normal',
            Icons.favorite_rounded,
            AppColors.green,
            '08:30',
          ),
          const SizedBox(height: 12),
          _buildDateHeader('Kemarin'),
          const SizedBox(height: 8),
          _buildHistoryItem(
            'Cek Kesehatan',
            'Suhu: 37.2°C • Ringan',
            Icons.favorite_rounded,
            AppColors.amber,
            '09:15',
          ),
          _buildHistoryItem(
            'Lokasi Dikunjungi',
            'Puskesmas Kecamatan',
            Icons.location_on_rounded,
            AppColors.primaryTeal,
            '14:00',
          ),
          const SizedBox(height: 12),
          _buildDateHeader('2 Hari Lalu'),
          const SizedBox(height: 8),
          _buildHistoryItem(
            'Cek Kesehatan',
            'Suhu: 36.8°C • Normal',
            Icons.favorite_rounded,
            AppColors.green,
            '07:45',
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: AppTypography.label.copyWith(color: AppColors.gray500),
      ),
    );
  }

  Widget _buildHistoryItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                ],
              ),
            ),
            Text(time, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
          ],
        ),
      ),
    );
  }
}
