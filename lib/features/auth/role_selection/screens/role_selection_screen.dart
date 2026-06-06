import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';

enum UserRole { pengguna, petugasMedis }

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  bool get _isButtonEnabled => _selectedRole != null;

  void _onLanjutkan() {
    if (!_isButtonEnabled) return;
    // TODO: Save selected role and navigate accordingly
    if (_selectedRole == UserRole.pengguna) {
      context.go('/dashboard');
    } else {
      context.go('/staff/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.8),
            radius: 1.2,
            colors: [
              Color(0x18009688),
              Colors.transparent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.air,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                Text(
                  'Pilih Peran Anda',
                  style: AppTypography.h1.copyWith(color: AppColors.gray900),
                ),
                const SizedBox(height: 8),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: Text(
                    'Pilih bagaimana Anda akan menggunakan aplikasi Respiro untuk pengalaman terbaik.',
                    style: AppTypography.body.copyWith(color: AppColors.gray500),
                  ),
                ),
                const SizedBox(height: 32),

                // Role Card - Pengguna
                RoleSelectionCard(
                  icon: Icons.person_outline,
                  title: 'Pengguna',
                  subtitle: 'Mencatat gejala harian & mencari faskes terdekat.',
                  isSelected: _selectedRole == UserRole.pengguna,
                  onTap: () => setState(() => _selectedRole = UserRole.pengguna),
                ),
                const SizedBox(height: 16),

                // Role Card - Petugas Medis
                RoleSelectionCard(
                  icon: Icons.medical_services_outlined,
                  title: 'Petugas Medis',
                  subtitle: 'Memantau data & riwayat pasien secara klinis.',
                  isSelected: _selectedRole == UserRole.petugasMedis,
                  onTap: () =>
                      setState(() => _selectedRole = UserRole.petugasMedis),
                ),

                const Spacer(),

                // Footer Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isButtonEnabled ? _onLanjutkan : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTeal,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      disabledBackgroundColor: AppColors.gray300,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.buttonRadius),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lanjutkan',
                          style: AppTypography.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isButtonEnabled
                                ? AppColors.white
                                : AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleSelectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.tealPale,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryTeal, size: 24),
            ),
            const SizedBox(width: 16),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.h3.copyWith(color: AppColors.gray900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.gray500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? AppColors.primaryTeal : AppColors.gray300,
                  width: isSelected ? 6 : 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: AppColors.primaryTeal,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
