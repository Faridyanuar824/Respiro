import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/widgets/public_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _userName = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final meta = user.userMetadata;
      if (meta != null && meta['full_name'] != null) {
        setState(() {
          _userName = meta['full_name'];
        });
      }
    }
  }

  Future<List<Map<String, String>>> _fetchTbcNews() async {
    try {
      final response = await Dio().get('https://www.bing.com/news/search?q=Tuberkulosis&format=rss');
      final document = XmlDocument.parse(response.data.toString());
      final items = document.findAllElements('item').take(10).toList();
      
      return items.map((node) {
        String? imageUrl;
        final images = node.descendants.where((e) => e is XmlElement && e.name.local == 'Image');
        if (images.isNotEmpty) {
          imageUrl = (images.first as XmlElement).innerText;
        }

        String? source;
        final sources = node.descendants.where((e) => e is XmlElement && e.name.local == 'Source');
        if (sources.isNotEmpty) {
          source = (sources.first as XmlElement).innerText;
        }

        return {
          'title': node.findElements('title').firstOrNull?.innerText ?? '',
          'link': node.findElements('link').firstOrNull?.innerText ?? '',
          'imageUrl': imageUrl ?? '',
          'source': source ?? '',
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

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
            Text('Halo, $_userName!', style: AppTypography.h1),
            const SizedBox(height: 4),
            Text(
              'Semoga pernapasanmu lega hari ini.',
              style: AppTypography.body.copyWith(color: AppColors.gray500),
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
            FutureBuilder<List<Map<String, String>>>(
              future: _fetchTbcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('Gagal memuat berita terbaru.', style: AppTypography.caption.copyWith(color: AppColors.gray500));
                }

                final articles = snapshot.data!;
                final colors = [AppColors.primaryTeal, AppColors.coral, AppColors.amber];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: articles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final color = colors[index % colors.length];
                      
                      final publisher = item['source']!.isNotEmpty ? item['source']! : 'Berita TBC';
                      final title = item['title'] ?? 'Tanpa Judul';

                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _buildHealthInfoCard(
                          context,
                          title: title,
                          category: publisher,
                          color: color,
                          url: item['link'] ?? 'https://news.google.com',
                          imageUrl: item['imageUrl']!.isNotEmpty ? item['imageUrl'] : null,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
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

  Widget _buildHealthInfoCard(BuildContext context, {required String title, required String category, required Color color, required String url, String? imageUrl}) {
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
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null ? Center(
                child: Icon(Icons.image_outlined, size: 48, color: color.withAlpha(100)),
              ) : null,
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
                    child: Text(
                      category,
                      style: AppTypography.caption.copyWith(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
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

