import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        title: const Text('Informasi Kesehatan'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Artikel Terbaru',
              style: AppTypography.h2,
            ),
            const SizedBox(height: 16),
            _buildArticleItem(
              context,
              title: 'Mengenal Penyakit Tuberkulosis (TBC) dan Gejalanya',
              category: 'Edukasi',
              date: 'Hari Ini',
              color: AppColors.coral,
              url: 'https://www.alodokter.com/tuberkulosis',
            ),
            const SizedBox(height: 12),
            _buildArticleItem(
              context,
              title: 'WHO: Situasi Tuberkulosis di Indonesia',
              category: 'Laporan',
              date: 'Kemarin',
              color: AppColors.primaryTeal,
              url: 'https://www.who.int/indonesia/health-topics/tuberculosis',
            ),
            const SizedBox(height: 12),
            _buildArticleItem(
              context,
              title: 'Wikipedia: Sejarah dan Penanganan Tuberkulosis',
              category: 'Informasi',
              date: '2 Hari yang lalu',
              color: AppColors.amber,
              url: 'https://id.wikipedia.org/wiki/Tuberkulosis',
            ),
            const SizedBox(height: 12),
            _buildArticleItem(
              context,
              title: 'Apa itu TBC? Kenali Penyebab dan Cara Mengobatinya',
              category: 'Kesehatan',
              date: '1 Minggu yang lalu',
              color: AppColors.primaryTeal,
              url: 'https://www.siloamhospitals.com/informasi-siloam/artikel/apa-itu-tbc',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, {required String title, required String category, required String date, required Color color, required String url}) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak dapat membuka tautan')),
            );
          }
        }
      },
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.image_outlined, color: color.withAlpha(100), size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withAlpha(20),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(category, style: AppTypography.caption.copyWith(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      Text(date, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
                      const Icon(Icons.open_in_new_rounded, size: 12, color: AppColors.gray500),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
