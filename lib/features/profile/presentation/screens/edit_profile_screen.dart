import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_input.dart';
import 'package:respiro/core/widgets/app_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Ubah Profil'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.tealPale,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 56),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 3),
                      ),
                      child: const Icon(Icons.camera_alt_rounded, color: AppColors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            AppInput(
              label: 'Nama Lengkap',
              hint: 'Sarah Jenkins',
              controller: TextEditingController(text: 'Sarah Jenkins'),
            ),
            const SizedBox(height: 16),
            AppInput(
              label: 'Email',
              hint: 'sarah@example.com',
              controller: TextEditingController(text: 'sarah@example.com'),
            ),
            const SizedBox(height: 16),
            AppInput(
              label: 'Nomor Telepon',
              hint: '+62 812 3456 7890',
              controller: TextEditingController(text: '+62 812 3456 7890'),
            ),
            const SizedBox(height: 16),
            AppInput(
              label: 'Alamat',
              hint: 'Kec. Setiabudi, Jakarta Selatan',
              controller: TextEditingController(text: 'Kec. Setiabudi, Jakarta Selatan'),
            ),
            const SizedBox(height: 48),
            AppButton(
              text: 'Simpan Perubahan',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profil berhasil diperbarui')),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
