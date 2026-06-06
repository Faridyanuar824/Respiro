import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/widgets/public_drawer.dart';

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: const Text('Respiro'),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.gray900,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const PublicDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 32),
            _buildMenuItem(
              icon: Icons.history_rounded,
              title: 'Riwayat Aktivitas',
              subtitle: 'Lihat aktivitas dan lokasi terakhir',
              onTap: () {
                context.go('/self-check');
              },
            ),
            const SizedBox(height: 16),
            _buildMenuItem(
              icon: Icons.settings_rounded,
              title: 'Pengaturan',
              subtitle: 'Keamanan dan notifikasi',
              onTap: () {
                context.push('/profile/settings');
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded, color: AppColors.coral),
                label: Text(
                  'Logout',
                  style: AppTypography.button.copyWith(color: AppColors.coral),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.coralPale, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.tealPale,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 40),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sarah Jenkins',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 14, color: AppColors.gray500),
                    const SizedBox(width: 4),
                    Text(
                      'Patient ID: #3492',
                      style: AppTypography.caption.copyWith(color: AppColors.gray500),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        context.push('/profile/edit');
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text('Ubah', style: AppTypography.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.tealPale,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryTeal, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.h3),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.gray300),
          ],
        ),
      ),
    );
  }
}
