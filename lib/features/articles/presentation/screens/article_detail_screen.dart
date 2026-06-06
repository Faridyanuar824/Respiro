import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Artikel'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, color: AppColors.gray900),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Artikel ditambahkan ke markah')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.gray900),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 240,
              color: AppColors.tealPale,
              child: const Center(
                child: Icon(Icons.image_outlined, size: 64, color: AppColors.primaryTeal),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withAlpha(20),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Tips Harian',
                      style: AppTypography.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Latihan Pernapasan Sederhana untuk Mengurangi Sesak',
                    style: AppTypography.h1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.gray200,
                        child: Icon(Icons.person, size: 20, color: AppColors.gray500),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dr. Respiro', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                            Text('Diterbitkan pada 30 Mei 2026', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: AppColors.gray200),
                  const SizedBox(height: 24),
                  Text(
                    'Sesak napas sering kali muncul tiba-tiba dan dapat memicu kepanikan. Padahal, kepanikan justru akan membuat sesak napas menjadi lebih buruk. Oleh karena itu, langkah pertama yang harus dilakukan adalah tetap tenang.\n\n'
                    'Berikut adalah beberapa teknik pernapasan yang dapat Anda coba saat merasa sesak:\n\n'
                    '1. Pursed-lip Breathing\n'
                    'Teknik ini membantu memperlambat pernapasan, menjaga saluran udara terbuka lebih lama, dan memfasilitasi pertukaran oksigen dan karbon dioksida. Caranya: tarik napas perlahan melalui hidung selama 2 detik, lalu embuskan perlahan melalui mulut dengan bibir dikerucutkan selama 4 detik.\n\n'
                    '2. Diaphragmatic Breathing\n'
                    'Pernapasan diafragma membantu menguatkan otot utama pernapasan. Letakkan satu tangan di dada dan satu di perut. Tarik napas melalui hidung, rasakan perut mengembang. Embuskan perlahan melalui mulut, rasakan perut mengempis.\n\n'
                    'Lakukan teknik ini selama 5-10 menit setiap hari untuk membiasakan paru-paru Anda. Jika sesak tidak kunjung reda, segera gunakan inhaler atau hubungi fasilitas kesehatan terdekat.',
                    style: AppTypography.body.copyWith(height: 1.6, color: AppColors.gray700),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
