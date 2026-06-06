import 'package:flutter/foundation.dart';
import 'package:respiro/features/staff/models/patient_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PatientProvider extends ChangeNotifier {
  List<PatientModel> _patients = [];
  List<PatientModel> _filteredPatients = [];
  String _searchQuery = '';
  String _riskFilter = 'Semua';
  bool _isLoading = false;

  List<PatientModel> get patients =>
      _searchQuery.isEmpty && _riskFilter == 'Semua'
          ? _patients
          : _filteredPatients;

  List<PatientModel> get allPatients => _patients;
  String get searchQuery => _searchQuery;
  String get riskFilter => _riskFilter;
  bool get isLoading => _isLoading;

  int get totalPatients => _patients.length;
  int get highRiskCount =>
      _patients.where((p) => p.riskLevel == 'High').length;
  int get mediumRiskCount =>
      _patients.where((p) => p.riskLevel == 'Medium').length;
  int get lowRiskCount =>
      _patients.where((p) => p.riskLevel == 'Low').length;

  PatientProvider() {
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('activities')
          .select()
          .order('created_at', ascending: false);

      final Map<String, PatientModel> uniquePatients = {};

      for (var row in response) {
        final userId = row['user_id'] as String? ?? 'Unknown';
        final symptomsList = (row['symptoms'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
        final location = row['location'] as String? ?? 'Surabaya';
        final createdAt = DateTime.tryParse(row['created_at'].toString()) ?? DateTime.now();

        // Tentukan tingkat risiko berdasarkan jumlah gejala
        int severity = symptomsList.length;
        String riskLevel = 'Low';
        if (severity >= 3) {
          riskLevel = 'High';
        } else if (severity >= 1) {
          riskLevel = 'Medium';
        }

        if (!uniquePatients.containsKey(userId)) {
          uniquePatients[userId] = PatientModel(
            id: userId.length > 8 ? userId.substring(0, 8) : userId,
            name: 'Pasien ${userId.length > 4 ? userId.substring(0, 4).toUpperCase() : "Anon"}',
            age: 0,
            gender: 'Anonim',
            symptom: symptomsList.isNotEmpty ? symptomsList.join(', ') : 'Tidak ada gejala',
            riskLevel: riskLevel,
            location: location,
            puskesmas: 'Belum Terdaftar',
            lastUpdate: createdAt,
            symptomHistory: [
              SymptomRecord(
                date: createdAt,
                symptom: symptomsList.isNotEmpty ? symptomsList.join(', ') : 'Aman',
                severity: severity,
              )
            ],
            visitHistory: [],
          );
        } else {
          // Tambahkan histori jika user sudah ada
          uniquePatients[userId]!.symptomHistory.add(
            SymptomRecord(
              date: createdAt,
              symptom: symptomsList.isNotEmpty ? symptomsList.join(', ') : 'Aman',
              severity: severity,
            ),
          );
        }
      }

      _patients = uniquePatients.values.toList();
      _patients.sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
    } catch (e) {
      debugPrint('Error fetching patients: $e');
    }

    _isLoading = false;
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void filterByRisk(String risk) {
    _riskFilter = risk;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<PatientModel>.from(_patients);

    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery) ||
                p.location.toLowerCase().contains(_searchQuery) ||
                p.id.toLowerCase().contains(_searchQuery),
          )
          .toList();
    }

    if (_riskFilter != 'Semua') {
      result =
          result.where((p) => p.riskLevel == _riskFilter).toList();
    }

    _filteredPatients = result;
  }

  PatientModel? getPatientById(String id) {
    try {
      return _patients.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void addPatient(PatientModel patient) {
    _patients.insert(0, patient);
    _applyFilters();
    notifyListeners();
  }

  List<PatientModel> getRecentPatients({int limit = 3}) {
    final sorted = List<PatientModel>.from(_patients)
      ..sort((a, b) => b.lastUpdate.compareTo(a.lastUpdate));
    return sorted.take(limit).toList();
  }

  List<PatientModel> getHighRiskPatients() {
    return _patients.where((p) => p.riskLevel == 'High').toList();
  }
}
