import 'package:flutter/material.dart';
import 'package:respiro/features/staff/models/analytics_model.dart';

class AnalyticsProvider extends ChangeNotifier {
  AnalyticsModel? _analytics;
  bool _isLoading = false;

  AnalyticsModel? get analytics => _analytics;
  bool get isLoading => _isLoading;

  AnalyticsProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    _analytics = AnalyticsModel(
      totalCases: 128,
      activePatients: 45,
      highRiskCount: 12,
      recoveredCount: 71,
      airQuality: 42,
      airQualityLabel: 'Baik',
      monthlyTrend: [
        MonthlyTrend(month: 'Jan', year: 2025, cases: 15),
        MonthlyTrend(month: 'Feb', year: 2025, cases: 20),
        MonthlyTrend(month: 'Mar', year: 2025, cases: 18),
        MonthlyTrend(month: 'Apr', year: 2025, cases: 25),
        MonthlyTrend(month: 'Mei', year: 2025, cases: 30),
        MonthlyTrend(month: 'Jun', year: 2025, cases: 20),
      ],
      regionalDistribution: [
        RegionalDistribution(
          region: 'Pusat',
          cases: 42,
          percentage: 32.8,
          colorHex: '#FF5722',
        ),
        RegionalDistribution(
          region: 'Utara',
          cases: 28,
          percentage: 21.9,
          colorHex: '#FFA726',
        ),
        RegionalDistribution(
          region: 'Selatan',
          cases: 15,
          percentage: 11.7,
          colorHex: '#009688',
        ),
        RegionalDistribution(
          region: 'Timur',
          cases: 25,
          percentage: 19.5,
          colorHex: '#4DB6AC',
        ),
        RegionalDistribution(
          region: 'Barat',
          cases: 18,
          percentage: 14.1,
          colorHex: '#00796B',
        ),
      ],
    );

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
