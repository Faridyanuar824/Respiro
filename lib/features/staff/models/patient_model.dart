import 'package:intl/intl.dart';

class SymptomRecord {
  final DateTime date;
  final String symptom;
  final int severity;

  SymptomRecord({
    required this.date,
    required this.symptom,
    required this.severity,
  });
}

class VisitRecord {
  final DateTime date;
  final String puskesmas;
  final String diagnosis;
  final String notes;

  VisitRecord({
    required this.date,
    required this.puskesmas,
    required this.diagnosis,
    this.notes = '',
  });
}

class PatientModel {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String symptom;
  final String riskLevel;
  final String location;
  final double latitude;
  final double longitude;
  final String puskesmas;
  final DateTime lastUpdate;
  final List<SymptomRecord> symptomHistory;
  final List<VisitRecord> visitHistory;

  PatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.symptom,
    required this.riskLevel,
    required this.location,
    this.latitude = 0,
    this.longitude = 0,
    this.puskesmas = '',
    DateTime? lastUpdate,
    List<SymptomRecord>? symptomHistory,
    List<VisitRecord>? visitHistory,
  })  : lastUpdate = lastUpdate ?? DateTime.now(),
        symptomHistory = symptomHistory ?? [],
        visitHistory = visitHistory ?? [];

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';

  String get ageGenderLabel => '$age th • $gender';

  String get lastUpdateLabel => DateFormat('dd MMM yyyy').format(lastUpdate);

  String get lastUpdateRelative {
    final diff = DateTime.now().difference(lastUpdate);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return DateFormat('dd MMM').format(lastUpdate);
  }
}
