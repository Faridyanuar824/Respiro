import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/public_drawer.dart';
import 'package:go_router/go_router.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  final List<Map<String, dynamic>> _facilities = [
    {
      'name': 'Puskesmas Ketabang',
      'category': 'Puskesmas',
      'address': 'Jl. Jaksa Agung Suprapto No.2',
      'distance': 1.2,
      'isOpen': true,
      'lat': -7.260400,
      'lng': 112.744100,
    },
    {
      'name': 'Klinik Sehat Bersama',
      'category': 'Klinik',
      'address': 'Jl. Merdeka No. 45',
      'distance': 1.5,
      'isOpen': true,
      'lat': -7.255,
      'lng': 112.750,
    },
    {
      'name': 'RSUD Dr. Soetomo',
      'category': 'Rumah Sakit',
      'address': 'Jl. Mayjen Prof. Dr. Moestopo No.6-8',
      'distance': 2.1,
      'isOpen': true,
      'lat': -7.267600,
      'lng': 112.758300,
    },
    {
      'name': 'Puskesmas Melati',
      'category': 'Puskesmas',
      'address': 'Jl. Sudirman No. 12',
      'distance': 2.5,
      'isOpen': true,
      'lat': -7.260,
      'lng': 112.755,
    },
    {
      'name': 'RS Siloam Surabaya',
      'category': 'Rumah Sakit',
      'address': 'Jl. Raya Gubeng No.70',
      'distance': 3.0,
      'isOpen': true,
      'lat': -7.274100,
      'lng': 112.747100,
    },
    {
      'name': 'Klinik Utama Kasih',
      'category': 'Klinik',
      'address': 'Jl. Gatot Subroto No. 8',
      'distance': 4.1,
      'isOpen': false,
      'lat': -7.265,
      'lng': 112.760,
    },
    {
      'name': 'Puskesmas Mulyorejo',
      'category': 'Puskesmas',
      'address': 'Jl. Mulyorejo Utara',
      'distance': 5.2,
      'isOpen': true,
      'lat': -7.266200,
      'lng': 112.784500,
    },
    {
      'name': 'RS Husada Utama',
      'category': 'Rumah Sakit',
      'address': 'Jl. Mayjen Prof. Dr. Moestopo No.31-35',
      'distance': 5.5,
      'isOpen': true,
      'lat': -7.264200,
      'lng': 112.754700,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredFacilities = _facilities.where((f) {
      final matchesSearch = f['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) || 
                            f['address'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'Semua' || f['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    filteredFacilities.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

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
            if (filteredFacilities.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
                child: Text('Tidak ada fasilitas yang ditemukan.', textAlign: TextAlign.center, style: AppTypography.body.copyWith(color: AppColors.gray500)),
              )
            else
              ...filteredFacilities.map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildFacilityCard(
                  context,
                  f['name'],
                  f['address'],
                  '${f['distance']} km',
                  f['isOpen'],
                  f['lat'],
                  f['lng'],
                ),
              )),
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
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.gray400, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
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
          _categoryChip('Semua'),
          const SizedBox(width: 8),
          _categoryChip('Puskesmas'),
          const SizedBox(width: 8),
          _categoryChip('Klinik'),
          const SizedBox(width: 8),
          _categoryChip('Rumah Sakit'),
        ],
      ),
    );
  }

  Widget _categoryChip(String label) {
    final isActive = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
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
      ),
    );
  }

  Widget _buildFacilityCard(
    BuildContext context,
    String name,
    String address,
    String distance,
    bool isOpen,
    double lat,
    double lng,
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
                        Expanded(child: Text(address, style: AppTypography.caption.copyWith(color: AppColors.gray500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gray100,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                  context.go(Uri(path: '/map', queryParameters: {
                    'lat': lat.toString(),
                    'lng': lng.toString(),
                    'title': name,
                  }).toString());
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
