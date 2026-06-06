import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _location = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Preferensi Aplikasi', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildSettingsContainer(
              children: [
                _buildSwitchTile(
                  title: 'Notifikasi',
                  subtitle: 'Terima peringatan kualitas udara dan jadwal',
                  icon: Icons.notifications_rounded,
                  value: _notifications,
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                const Divider(color: AppColors.gray200, height: 1),
                _buildSwitchTile(
                  title: 'Mode Gelap',
                  subtitle: 'Gunakan tema gelap pada aplikasi',
                  icon: Icons.dark_mode_rounded,
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
                const Divider(color: AppColors.gray200, height: 1),
                _buildSwitchTile(
                  title: 'Layanan Lokasi',
                  subtitle: 'Akses lokasi untuk akurasi peta & udara',
                  icon: Icons.location_on_rounded,
                  value: _location,
                  onChanged: (v) => setState(() => _location = v),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Akun & Keamanan', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildSettingsContainer(
              children: [
                _buildListTile(
                  title: 'Ubah Kata Sandi',
                  icon: Icons.lock_rounded,
                  onTap: () {},
                ),
                const Divider(color: AppColors.gray200, height: 1),
                _buildListTile(
                  title: 'Bahasa',
                  icon: Icons.language_rounded,
                  trailing: Text('Bahasa Indonesia', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Lainnya', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildSettingsContainer(
              children: [
                _buildListTile(
                  title: 'Kebijakan Privasi',
                  icon: Icons.privacy_tip_rounded,
                  onTap: () {},
                ),
                const Divider(color: AppColors.gray200, height: 1),
                _buildListTile(
                  title: 'Syarat & Ketentuan',
                  icon: Icons.description_rounded,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.tealPale,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryTeal, size: 20),
      ),
      activeColor: AppColors.primaryTeal,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return ListTile(
      onTap: onTap,
      title: Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.tealPale,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primaryTeal, size: 20),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right_rounded, color: AppColors.gray300),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
