import 'package:flutter/material.dart';
import 'package:respiro/features/staff/models/analytics_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsProvider extends ChangeNotifier {
  AnalyticsModel? _analytics;
  bool _isLoading = false;

  AnalyticsModel? get analytics => _analytics;
  bool get isLoading => _isLoading;

  AnalyticsProvider() {
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client.from('activities').select();
      
      int totalCases = response.length;
      int activePatients = 0;
      int highRiskCount = 0;
      int recoveredCount = 0;
      
      Map<String, int> regionCounts = {};
      
      for (var row in response) {
        final symptomsList = (row['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        if (symptomsList.isNotEmpty) {
          activePatients++;
          if (symptomsList.length >= 3) {
            highRiskCount++;
          }
        } else {
          recoveredCount++;
        }
        
        final loc = row['location'] as String? ?? 'Lainnya';
        regionCounts[loc] = (regionCounts[loc] ?? 0) + 1;
      }
      
      List<RegionalDistribution> regionalDistribution = [];
      final colors = ['#00796B', '#FF5722', '#FFA726', '#4DB6AC', '#009688', '#E91E63'];
      int colorIndex = 0;
      
      regionCounts.forEach((region, count) {
        regionalDistribution.add(RegionalDistribution(
          region: region,
          cases: count,
          percentage: totalCases > 0 ? (count / totalCases) * 100 : 0,
          colorHex: colors[colorIndex % colors.length],
        ));
        colorIndex++;
      });
      
      regionalDistribution.sort((a, b) => b.cases.compareTo(a.cases));

      _analytics = AnalyticsModel(
        totalCases: totalCases,
        activePatients: activePatients,
        highRiskCount: highRiskCount,
        recoveredCount: recoveredCount,
        airQuality: 42,
        airQualityLabel: 'Baik',
        monthlyTrend: [
          MonthlyTrend(month: 'Jun', year: 2026, cases: totalCases),
        ],
        regionalDistribution: regionalDistribution,
      );
      
    } catch (e) {
      debugPrint('Error fetching analytics: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Color getColorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  List<Color> get regionalColors =>
      _analytics?.regionalDistribution
          .map((r) => getColorFromHex(r.colorHex))
          .toList() ??
      [];
}
