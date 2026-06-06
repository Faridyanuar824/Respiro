import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:xml/xml.dart';

class ArticleListScreen extends StatefulWidget {
  const ArticleListScreen({super.key});

  @override
  State<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  Future<List<Map<String, String>>> _fetchTbcNews() async {
    try {
      final response = await Dio().get('https://www.bing.com/news/search?q=Tuberkulosis&format=rss');
      final document = XmlDocument.parse(response.data.toString());
      final items = document.findAllElements('item').take(20).toList();
      
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
          'pubDate': node.findElements('pubDate').firstOrNull?.innerText ?? '',
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
            FutureBuilder<List<Map<String, String>>>(
              future: _fetchTbcNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('Gagal memuat berita terbaru.');
                }

                final articles = snapshot.data!;
                final colors = [AppColors.primaryTeal, AppColors.coral, AppColors.amber];

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: articles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = articles[index];
                    final color = colors[index % colors.length];

                    final publisher = item['source']!.isNotEmpty ? item['source']! : 'Berita TBC';
                    final title = item['title'] ?? 'Tanpa Judul';

                    // Mengambil waktu sederhana
                    String dateStr = 'Hari Ini';
                    if (item['pubDate'] != null && item['pubDate']!.isNotEmpty) {
                      dateStr = item['pubDate']!.split(' ').take(4).join(' ');
                    }

                    return _buildArticleItem(
                      context,
                      title: title,
                      category: publisher,
                      date: dateStr,
                      color: color,
                      url: item['link'] ?? 'https://news.google.com',
                      imageUrl: item['imageUrl']!.isNotEmpty ? item['imageUrl'] : null,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleItem(BuildContext context, {required String title, required String category, required String date, required Color color, required String url, String? imageUrl}) {
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
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null ? Icon(Icons.image_outlined, color: color.withAlpha(100), size: 32) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
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
                      ),
                      const SizedBox(width: 8),
                      Text(date, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
                      const SizedBox(width: 4),
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
