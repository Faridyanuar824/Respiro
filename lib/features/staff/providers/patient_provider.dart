import 'package:flutter/foundation.dart';
import 'package:respiro/features/staff/models/patient_model.dart';

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
    _loadMockData();
  }

  void _loadMockData() {
    _isLoading = true;
    notifyListeners();

    _patients = [
      PatientModel(
        id: 'P001',
        name: 'Andi Pratama',
        age: 35,
        gender: 'Laki-laki',
        symptom: 'Batuk berdahak, sesak napas',
        riskLevel: 'High',
        location: 'Kecamatan Pusat, Surabaya',
        puskesmas: 'Puskesmas Pusat',
        lastUpdate: DateTime.now().subtract(const Duration(hours: 2)),
        symptomHistory: [
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(days: 1)),
            symptom: 'Batuk berdahak',
            severity: 3,
          ),
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(days: 3)),
            symptom: 'Demam tinggi',
            severity: 4,
          ),
        ],
        visitHistory: [
          VisitRecord(
            date: DateTime.now().subtract(const Duration(days: 1)),
            puskesmas: 'Puskesmas Pusat',
            diagnosis: 'ISPA Akut',
            notes: 'Pemberian antibiotik',
          ),
        ],
      ),
      PatientModel(
        id: 'P002',
        name: 'Siti Rahayu',
        age: 28,
        gender: 'Perempuan',
        symptom: 'Batuk ringan, pilek',
        riskLevel: 'Medium',
        location: 'Kecamatan Utara, Surabaya',
        puskesmas: 'Puskesmas Utara',
        lastUpdate: DateTime.now().subtract(const Duration(days: 1)),
        symptomHistory: [
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(days: 2)),
            symptom: 'Batuk ringan',
            severity: 2,
          ),
        ],
        visitHistory: [
          VisitRecord(
            date: DateTime.now().subtract(const Duration(days: 2)),
            puskesmas: 'Puskesmas Utara',
            diagnosis: 'ISPA Ringan',
            notes: 'Rawat jalan',
          ),
        ],
      ),
      PatientModel(
        id: 'P003',
        name: 'Budi Santoso',
        age: 45,
        gender: 'Laki-laki',
        symptom: 'Tidak ada gejala',
        riskLevel: 'Low',
        location: 'Kecamatan Selatan, Surabaya',
        puskesmas: 'Puskesmas Selatan',
        lastUpdate: DateTime.now().subtract(const Duration(days: 5)),
        symptomHistory: [],
        visitHistory: [],
      ),
      PatientModel(
        id: 'P004',
        name: 'Dewi Lestari',
        age: 22,
        gender: 'Perempuan',
        symptom: 'Sesak napas, demam',
        riskLevel: 'High',
        location: 'Kecamatan Timur, Surabaya',
        puskesmas: 'Puskesmas Timur',
        lastUpdate: DateTime.now().subtract(const Duration(hours: 6)),
        symptomHistory: [
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(hours: 6)),
            symptom: 'Sesak napas',
            severity: 4,
          ),
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(days: 1)),
            symptom: 'Demam tinggi',
            severity: 3,
          ),
        ],
        visitHistory: [
          VisitRecord(
            date: DateTime.now().subtract(const Duration(hours: 6)),
            puskesmas: 'Puskesmas Timur',
            diagnosis: 'ISPA Berat',
            notes: 'Dirujuk ke RSUD',
          ),
        ],
      ),
      PatientModel(
        id: 'P005',
        name: 'Ahmad Fauzi',
        age: 50,
        gender: 'Laki-laki',
        symptom: 'Batuk kronis',
        riskLevel: 'Medium',
        location: 'Kecamatan Barat, Surabaya',
        puskesmas: 'Puskesmas Barat',
        lastUpdate: DateTime.now().subtract(const Duration(days: 3)),
        symptomHistory: [
          SymptomRecord(
            date: DateTime.now().subtract(const Duration(days: 3)),
            symptom: 'Batuk kronis',
            severity: 3,
          ),
        ],
        visitHistory: [],
      ),
      PatientModel(
        id: 'P006',
        name: 'Maya Indah',
        age: 30,
        gender: 'Perempuan',
        symptom: 'Pilek, bersin',
        riskLevel: 'Low',
        location: 'Kecamatan Pusat, Surabaya',
        puskesmas: 'Puskesmas Pusat',
        lastUpdate: DateTime.now().subtract(const Duration(days: 7)),
        symptomHistory: [],
        visitHistory: [],
      ),
    ];

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
