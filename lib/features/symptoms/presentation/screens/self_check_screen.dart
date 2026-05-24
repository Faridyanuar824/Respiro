import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/app_button.dart';

class SelfCheckScreen extends StatefulWidget {
  const SelfCheckScreen({super.key});

  @override
  State<SelfCheckScreen> createState() => _SelfCheckScreenState();
}

class _SelfCheckScreenState extends State<SelfCheckScreen> {
  double _temperature = 36.5;
  int _coughLevel = 0;
  int _breathingLevel = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cek Kesehatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suhu Tubuh', style: AppTypography.h3),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '${_temperature.toStringAsFixed(1)}°C',
                      style: AppTypography.h1.copyWith(color: AppColors.primaryTeal, fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Slider(
                    value: _temperature,
                    min: 35.0,
                    max: 42.0,
                    divisions: 140,
                    activeColor: AppColors.primaryTeal,
                    onChanged: (value) => setState(() => _temperature = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('35.0', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                      Text('42.0', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tingkat Batuk', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  _buildLevelSelector(0, 'Tidak Batuk', Icons.check_circle_outline),
                  _buildLevelSelector(1, 'Batuk Ringan', Icons.healing_outlined),
                  _buildLevelSelector(2, 'Batuk Sedang', Icons.healing_rounded),
                  _buildLevelSelector(3, 'Batuk Parah', Icons.warning_rounded),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tingkat Pernapasan', style: AppTypography.h3),
                  const SizedBox(height: 12),
                  _buildBreathingSelector(0, 'Normal', Icons.check_circle_outline),
                  _buildBreathingSelector(1, 'Sesak Ringan', Icons.healing_outlined),
                  _buildBreathingSelector(2, 'Sesak Sedang', Icons.healing_rounded),
                  _buildBreathingSelector(3, 'Sesak Parah', Icons.warning_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Simpan Hasil Cek',
              isLoading: _isLoading,
              onPressed: () {
                setState(() => _isLoading = true);
                final messenger = ScaffoldMessenger.of(context);
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() => _isLoading = false);
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Text('Hasil cek kesehatan disimpan'),
                        backgroundColor: AppColors.primaryTeal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelector(int level, String label, IconData icon) {
    final isSelected = _coughLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _coughLevel = level),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.tealPale : AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : AppColors.gray200,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? AppColors.primaryTeal : AppColors.gray500),
              const SizedBox(width: 12),
              Text(label, style: AppTypography.body),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreathingSelector(int level, String label, IconData icon) {
    final isSelected = _breathingLevel == level;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => setState(() => _breathingLevel = level),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.tealPale : AppColors.gray100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primaryTeal : AppColors.gray200,
            ),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: isSelected ? AppColors.primaryTeal : AppColors.gray500),
              const SizedBox(width: 12),
              Text(label, style: AppTypography.body),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.primaryTeal, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
