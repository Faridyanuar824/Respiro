import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class PublicDrawer extends StatefulWidget {
  const PublicDrawer({super.key});

  @override
  State<PublicDrawer> createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  String _userName = 'Pengguna';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final meta = user.userMetadata;
      setState(() {
        if (meta != null && meta['full_name'] != null) {
          _userName = meta['full_name'];
        }
        _userEmail = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard',
                  onTap: () {
                    context.pop();
                    context.go('/dashboard');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.map_rounded,
                  title: 'Peta Interaktif',
                  onTap: () {
                    context.pop();
                    context.go('/map');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.location_on_rounded,
                  title: 'Catatan Aktivitas',
                  onTap: () {
                    context.pop();
                    context.go('/self-check');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.local_hospital_rounded,
                  title: 'Fasilitas Kesehatan',
                  onTap: () {
                    context.pop();
                    context.go('/facilities');
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Divider(color: AppColors.gray200, height: 1),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_rounded,
                  title: 'Profil Saya',
                  onTap: () {
                    context.pop();
                    context.go('/profile');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Pusat Bantuan',
                  onTap: () {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pusat Bantuan akan segera hadir!')),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'Tentang Aplikasi',
                  onTap: () {
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Respiro v1.0.0')),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.pop();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.coral, size: 20),
                label: Text(
                  'Logout',
                  style: AppTypography.button.copyWith(color: AppColors.coral),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.coralPale, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.tealPale,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_userName, style: AppTypography.h3),
                Text(_userEmail.isEmpty ? 'Aktif' : _userEmail, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: AppColors.gray500, size: 24),
      title: Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.gray900)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    );
  }
}
