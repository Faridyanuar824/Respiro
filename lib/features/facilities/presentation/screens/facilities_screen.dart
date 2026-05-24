import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';

class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fasilitas Kesehatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryRow(),
            const SizedBox(height: 16),
            _buildFacilityCard(
              'Puskesmas Kecamatan Pusat',
              'Jl. Kesehatan No. 1',
              '1.2 km',
              Icons.local_hospital_rounded,
              AppColors.primaryTeal,
            ),
            const SizedBox(height: 12),
            _buildFacilityCard(
              'Rumah Sakit Umum Daerah',
              'Jl. Medika No. 10',
              '2.5 km',
              Icons.local_hospital_rounded,
              AppColors.coral,
            ),
            const SizedBox(height: 12),
            _buildFacilityCard(
              'Klinik Sehat Keluarga',
              'Jl. Sejahtera No. 5',
              '0.8 km',
              Icons.medical_services_rounded,
              AppColors.tealMid,
            ),
            const SizedBox(height: 12),
            _buildFacilityCard(
              'Apotek Sehat',
              'Jl. Raya No. 22',
              '0.5 km',
              Icons.local_pharmacy_rounded,
              AppColors.amber,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.gray500, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari fasilitas kesehatan...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _categoryChip('Semua', true),
          const SizedBox(width: 8),
          _categoryChip('Puskesmas', false),
          const SizedBox(width: 8),
          _categoryChip('Rumah Sakit', false),
          const SizedBox(width: 8),
          _categoryChip('Klinik', false),
          const SizedBox(width: 8),
          _categoryChip('Apotek', false),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryTeal : AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isActive ? AppColors.primaryTeal : AppColors.gray300,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: isActive ? AppColors.white : AppColors.gray700,
        ),
      ),
    );
  }

  Widget _buildFacilityCard(
    String name,
    String address,
    String distance,
    IconData icon,
    Color color,
  ) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(address, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
          ),
          Text(distance, style: AppTypography.label.copyWith(color: AppColors.primaryTeal)),
        ],
      ),
    );
  }
}
