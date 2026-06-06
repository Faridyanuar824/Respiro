class MonthlyTrend {
  final String month;
  final int year;
  final int cases;

  MonthlyTrend({required this.month, required this.year, required this.cases});
}

class RegionalDistribution {
  final String region;
  final int cases;
  final double percentage;
  final String colorHex;

  RegionalDistribution({
    required this.region,
    required this.cases,
    required this.percentage,
    required this.colorHex,
  });
}

class AnalyticsModel {
  final int totalCases;
  final int activePatients;
  final int highRiskCount;
  final int recoveredCount;
  final double airQuality;
  final String airQualityLabel;
  final List<MonthlyTrend> monthlyTrend;
  final List<RegionalDistribution> regionalDistribution;

  AnalyticsModel({
    required this.totalCases,
    required this.activePatients,
    required this.highRiskCount,
    required this.recoveredCount,
    required this.airQuality,
    required this.airQualityLabel,
    required this.monthlyTrend,
    required this.regionalDistribution,
  });

  int get todaysNewCases => monthlyTrend.isNotEmpty ? monthlyTrend.last.cases : 0;
}
