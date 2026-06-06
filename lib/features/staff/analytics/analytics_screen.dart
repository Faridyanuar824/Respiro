import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/features/staff/widgets/stats_card.dart';
import 'package:respiro/features/staff/widgets/analytics_chart.dart';
import 'package:respiro/features/staff/providers/analytics_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AnalyticsProvider>();
    final analytics = provider.analytics;

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(
        title: 'Analytics',
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: AppColors.gray700),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryRow(analytics),
            const SizedBox(height: 16),
            _buildMonthlyTrendChart(analytics),
            const SizedBox(height: 16),
            _buildRegionalPieChart(analytics),
            const SizedBox(height: 16),
            _buildISPAStats(analytics),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(dynamic analytics) {
    return Row(
      children: [
        Expanded(
          child: StatsCard(
            title: 'Total Kasus',
            value: '${analytics?.totalCases ?? 0}',
            icon: Icons.medical_services_rounded,
            color: AppColors.primaryTeal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            title: 'Sembuh',
            value: '${analytics?.recoveredCount ?? 0}',
            icon: Icons.favorite_rounded,
            color: AppColors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatsCard(
            title: 'Aktif',
            value: '${analytics?.activePatients ?? 0}',
            icon: Icons.people_rounded,
            color: AppColors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyTrendChart(dynamic analytics) {
    final monthlyData = analytics?.monthlyTrend ?? [];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Bulanan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Jumlah kasus ISPA per bulan',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 16),
          BarChartWidget(data: monthlyData),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRegionalPieChart(dynamic analytics) {
    final regionalData = analytics?.regionalDistribution ?? [];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Regional',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Persebaran kasus per kecamatan',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.gray500,
            ),
          ),
          const SizedBox(height: 16),
          PieChartWidget(data: regionalData),
        ],
      ),
    );
  }

  Widget _buildISPAStats(dynamic analytics) {
    final regions = analytics?.regionalDistribution ?? [];
    if (regions.isEmpty) {
      return const SizedBox.shrink();
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistik ISPA per Wilayah',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          ...regions.map((region) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: _getColor(region.colorHex),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            region.region,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.gray700,
                            ),
                          ),
                        ],
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
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: region.percentage / 100,
                      backgroundColor: AppColors.gray200,
                      valueColor: AlwaysStoppedAnimation(
                        _getColor(region.colorHex),
                      ),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${region.percentage.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.gray500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
