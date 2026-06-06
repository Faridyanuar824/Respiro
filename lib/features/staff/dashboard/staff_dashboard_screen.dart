import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/features/staff/widgets/stats_card.dart';
import 'package:respiro/features/staff/widgets/section_title.dart';
import 'package:respiro/features/staff/widgets/patient_card.dart';
import 'package:respiro/features/staff/providers/patient_provider.dart';
import 'package:respiro/features/staff/providers/analytics_provider.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final analytics = analyticsProvider.analytics;
    final recentPatients = patientProvider.getRecentPatients(limit: 3);

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.gray700),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 16),
            _buildStatRow(patientProvider, analytics),
            const SizedBox(height: 16),
            _buildTopRiskRegionCard(analytics),
            const SizedBox(height: 16),
            _buildQuickActions(context),
            const SizedBox(height: 16),
            _buildRegionDistribution(analytics),
            const SizedBox(height: 16),
            SectionTitle(
              title: 'Pasien Terbaru',
              actionLabel: 'Lihat Semua',
              onAction: () => context.go('/staff/patients'),
            ),
            const SizedBox(height: 12),
            ...recentPatients.map<Widget>(
              (patient) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PatientCard(
                  patient: patient,
                  onTap: () => context.push('/staff/patients/detail', extra: patient.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Pagi,',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.gray500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Staff Respiro',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.gray900,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(PatientProvider patientProvider, analytics) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Total Kasus',
            value: '${analytics?.totalCases ?? 0}',
            icon: Icons.medical_services_rounded,
            color: AppColors.primaryTeal,
            change: 8.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            title: 'Pasien Aktif',
            value: '${analytics?.activePatients ?? 0}',
            icon: Icons.people_rounded,
            color: AppColors.amber,
            change: -2.1,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            title: 'Risiko Tinggi',
            value: '${analytics?.highRiskCount ?? 0}',
            icon: Icons.warning_rounded,
            color: AppColors.coral,
            change: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTopRiskRegionCard(dynamic analytics) {
    final regions = analytics?.regionalDistribution ?? [];
    if (regions.isEmpty) return const SizedBox.shrink();
    
    final topRegion = regions.first;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.coral.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Icon(Icons.warning_amber_rounded, color: AppColors.coral, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kawasan Paling Rawan',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.gray500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  topRegion.region,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coral,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${topRegion.cases} Kasus Tercatat',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.location_on_rounded, color: AppColors.coral.withAlpha(60), size: 36),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.person_add_rounded,
            label: 'Tambah Pasien',
            color: AppColors.primaryTeal,
            onTap: () => context.push('/staff/patients/add'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            context,
            icon: Icons.bar_chart_rounded,
            label: 'Lihat Statistik',
            color: AppColors.tealDark,
            onTap: () => context.go('/staff/analytics'),
          ),
        ),
      ],
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionDistribution(dynamic analytics) {
    final regions = analytics?.regionalDistribution ?? [];

    if (regions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribusi Wilayah',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        const SizedBox(height: 12),
        AppCard(
          child: Column(
            children: [
              for (var region in regions)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _getColor(region.colorHex),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          region.region,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.gray700,
                          ),
                        ),
                      ),
                      Text(
                        '${region.cases} kasus',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
