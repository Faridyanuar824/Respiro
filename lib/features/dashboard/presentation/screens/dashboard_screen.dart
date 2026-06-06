import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/widgets/public_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Respiro',
          style: AppTypography.h2.copyWith(color: AppColors.primaryTeal),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.tealPale,
              child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 20),
            ),
          ),
        ],
      ),
      drawer: const PublicDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo, Sarah!', style: AppTypography.h1),
            const SizedBox(height: 4),
            Text(
              'Semoga pernapasanmu lega hari ini.',
              style: AppTypography.body.copyWith(color: AppColors.gray500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildAirQualityCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildInhalerCard()),
              ],
            ),
            const SizedBox(height: 24),
            _buildDailyCheckCard(context),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Informasi Kesehatan', style: AppTypography.h2),
                TextButton(
                  onPressed: () {
                    context.push('/articles');
                  },
                  child: Text('Lihat Semua', style: AppTypography.caption.copyWith(color: AppColors.primaryTeal)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildHealthInfoCard(
                    context,
                    title: 'Mengenal Penyakit Tuberkulosis (TBC) dan Gejalanya',
                    category: 'Edukasi',
                    color: AppColors.primaryTeal,
                    url: 'https://www.alodokter.com/tuberkulosis',
                  ),
                  const SizedBox(width: 16),
                  _buildHealthInfoCard(
                    context,
                    title: 'WHO: Situasi Tuberkulosis di Indonesia dan Pencegahannya',
                    category: 'Kesehatan',
                    color: AppColors.amber,
                    url: 'https://www.who.int/indonesia/health-topics/tuberculosis',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirQualityCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.air_rounded, color: AppColors.primaryTeal, size: 16),
              const SizedBox(width: 8),
              Text('KUALITAS\nUDARA', style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('42', style: AppTypography.h1.copyWith(fontSize: 32)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.green.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Baik', style: AppTypography.caption.copyWith(color: AppColors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Aman untuk\naktivitas luar.', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
        ],
      ),
    );
  }

  Widget _buildInhalerCard() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medication_liquid_rounded, color: AppColors.coral, size: 16),
              const SizedBox(width: 8),
              Text('INHALER', style: AppTypography.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.coral)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('0', style: AppTypography.h1.copyWith(fontSize: 32)),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text('Kali hari ini', style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Belum ada\npenggunaan.', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
        ],
      ),
    );
  }

  Widget _buildDailyCheckCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/self-check'),
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
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.tealPale,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.assignment_rounded, color: AppColors.primaryTeal),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Catatan Gejala Hari Ini', style: AppTypography.h3),
                const SizedBox(height: 4),
                Text(
                  'Bagaimana kondisimu pagi ini? Yuk, catat gejalamu agar riwayat kesehatanmu terpantau.',
                  style: AppTypography.caption.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primaryTeal,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildHealthInfoCard(BuildContext context, {required String title, required String category, required Color color, required String url}) {
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
      child: Container(
        width: 240,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(Icons.image_outlined, size: 48, color: color.withAlpha(100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(category, style: AppTypography.caption.copyWith(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
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

