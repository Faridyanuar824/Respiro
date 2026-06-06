import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/public_drawer.dart';

class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Respiro',
          style: AppTypography.h2.copyWith(color: AppColors.primaryTeal),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.tealPale,
              child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 20),
            ),
          ),
        ],
      ),
      drawer: const PublicDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryRow(),
            const SizedBox(height: 24),
            Text('Fasilitas Terdekat', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildFacilityCard(
              context,
              'Klinik Sehat Bersama',
              'Jl. Merdeka No. 45',
              '1.2 km',
              true,
            ),
            const SizedBox(height: 12),
            _buildFacilityCard(
              context,
              'Puskesmas Melati',
              'Jl. Sudirman No. 12',
              '2.5 km',
              true,
            ),
            const SizedBox(height: 12),
            _buildFacilityCard(
              context,
              'Klinik Utama Kasih',
              'Jl. Gatot Subroto No. 8',
              '4.1 km',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.gray200),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.gray400, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari klinik atau rumah sakit...',
                hintStyle: TextStyle(color: AppColors.gray400, fontSize: 14),
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
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _categoryChip('Semua', true),
          const SizedBox(width: 8),
          _categoryChip('Puskesmas', false),
          const SizedBox(width: 8),
          _categoryChip('Klinik', false),
          const SizedBox(width: 8),
          _categoryChip('Rumah Sakit', false),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryTeal : AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isActive ? AppColors.primaryTeal : AppColors.gray200,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: isActive ? AppColors.white : AppColors.gray700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFacilityCard(
    BuildContext context,
    String name,
    String address,
    String distance,
    bool isOpen,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTypography.h3),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.gray500),
                        const SizedBox(width: 4),
                        Text(address, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isOpen ? AppColors.primaryTeal : AppColors.gray400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOpen ? 'Buka' : 'Tutup',
                      style: AppTypography.caption.copyWith(
                        color: isOpen ? AppColors.primaryTeal : AppColors.gray500,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.gray200),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jarak', style: AppTypography.caption.copyWith(color: AppColors.gray400, fontSize: 10)),
                  Text(distance, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Memulai navigasi ke $name...')),
                  );
                },
                icon: const Icon(Icons.navigation_outlined, color: AppColors.primaryTeal, size: 16),
                label: Text('Navigasi', style: AppTypography.button.copyWith(color: AppColors.primaryTeal)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealPale,
                  foregroundColor: AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
