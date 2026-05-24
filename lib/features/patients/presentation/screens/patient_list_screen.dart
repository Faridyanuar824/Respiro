import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pasien'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMd),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.gray500, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Cari pasien...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMd),
              children: [
                _buildPatientCard('Andi Pratama', 35, 'Laki-laki', 'High', AppColors.coral),
                const SizedBox(height: 8),
                _buildPatientCard('Siti Rahayu', 28, 'Perempuan', 'Medium', AppColors.amber),
                const SizedBox(height: 8),
                _buildPatientCard('Budi Santoso', 45, 'Laki-laki', 'Low', AppColors.primaryTeal),
                const SizedBox(height: 8),
                _buildPatientCard('Dewi Lestari', 22, 'Perempuan', 'High', AppColors.coral),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(String name, int age, String gender, String risk, Color riskColor) {
    return AppCard(
      onTap: () {},
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.tealPale,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                name[0],
                style: AppTypography.h3.copyWith(color: AppColors.primaryTeal),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('$age th • $gender', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: riskColor.withAlpha(30),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              risk,
              style: AppTypography.label.copyWith(color: riskColor),
            ),
          ),
        ],
      ),
    );
  }
}
