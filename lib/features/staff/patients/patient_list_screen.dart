import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/features/staff/widgets/patient_card.dart';
import 'package:respiro/features/staff/providers/patient_provider.dart';

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
    final provider = context.watch<PatientProvider>();
    final patients = provider.patients;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(
        title: 'Data Pasien',
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: AppColors.primaryTeal),
            onPressed: () => context.push('/staff/patients/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(provider),
          Expanded(
            child: patients.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMd,
                    ),
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: PatientCard(
                          patient: patient,
                          onTap: () => context.push(
                            '/staff/patients/detail',
                            extra: patient.id,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMd,
        AppConstants.paddingMd,
        AppConstants.paddingMd,
        0,
      ),
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
                  hintStyle: TextStyle(color: AppColors.gray300),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) {
                  context.read<PatientProvider>().search(value);
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _searchController.clear();
                  context.read<PatientProvider>().search('');
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.gray500,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(PatientProvider provider) {
    final filters = ['Semua', 'High', 'Medium', 'Low'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingMd,
        12,
        AppConstants.paddingMd,
        12,
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = provider.riskFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => provider.filterByRisk(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? _getFilterColor(filter).withAlpha(30)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? _getFilterColor(filter)
                        : AppColors.gray200,
                  ),
                ),
                child: Text(
                  filter == 'Semua' ? 'Semua' : filter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? _getFilterColor(filter)
                        : AppColors.gray500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'High':
        return AppColors.coral;
      case 'Medium':
        return AppColors.amber;
      case 'Low':
        return AppColors.primaryTeal;
      default:
        return AppColors.primaryTeal;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.gray300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Pasien tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Coba kata kunci atau filter lain',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.gray300,
            ),
          ),
        ],
      ),
    );
  }
}
