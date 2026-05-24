class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String profile = '/auth/profile';

  static const String patients = '/patients';
  static const String activities = '/activities';

  static const String selfCheck = '/self-check';
  static const String selfCheckHistory = '/self-check/history';

  static const String hotspots = '/maps/hotspots';
  static const String distribution = '/maps/distribution';

  static const String dashboard = '/analytics/dashboard';
  static const String regions = '/analytics/regions';
}
