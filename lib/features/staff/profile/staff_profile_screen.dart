import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/app_button.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/store/app_store.dart';

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appStore = context.watch<AppStore>();

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(title: 'Profil'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          children: [
            _buildProfileHeader(appStore),
            const SizedBox(height: 16),
            _buildInfoCard(appStore),
            const SizedBox(height: 16),
            _buildMenuSection(
              title: 'Umum',
              items: [
                _MenuItem(
                  icon: Icons.schedule_rounded,
                  label: 'Jadwal',
                  color: AppColors.primaryTeal,
                ),
                _MenuItem(
                  icon: Icons.settings_rounded,
                  label: 'Pengaturan',
                  color: AppColors.tealMid,
                ),
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  label: 'Bantuan',
                  color: AppColors.amber,
                ),
                _MenuItem(
                  icon: Icons.info_outline_rounded,
                  label: 'Tentang Aplikasi',
                  color: AppColors.gray500,
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Keluar',
              isDanger: true,
              icon: Icons.logout_rounded,
              onPressed: () => _showLogoutDialog(context, appStore),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppStore appStore) {
    final userName = appStore.userName;
    return AppCard(
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryTeal, AppColors.tealMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                (userName != null && userName.isNotEmpty)
                    ? userName[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName ?? 'Staff Respiro',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tealPale,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'Staff Kesehatan',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppStore appStore) {
    return AppCard(
      child: Column(
        children: [
          _infoRow(Icons.email_outlined, 'Email', appStore.userEmail ?? 'staff@respiro.com'),
          const Divider(height: 20),
          _infoRow(Icons.badge_outlined, 'Role', 'Staff Kesehatan'),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryTeal),
        const SizedBox(width: 12),
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.gray900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: item.color.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          size: 18,
                          color: item.color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.gray900,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.gray300,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppStore appStore) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Keluar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.gray900,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: AppColors.gray700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.gray500),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              appStore.logout();
              context.go('/login');
            },
            child: const Text(
              'Keluar',
              style: TextStyle(
                color: AppColors.coral,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}
