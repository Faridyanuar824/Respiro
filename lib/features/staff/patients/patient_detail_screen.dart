import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/app_button.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/features/staff/widgets/risk_badge.dart';
import 'package:respiro/features/staff/providers/patient_provider.dart';
import 'package:respiro/features/staff/models/patient_model.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientId = GoRouterState.of(context).extra as String?;
    if (patientId == null) {
      return const Scaffold(
        body: Center(child: Text('ID pasien tidak ditemukan')),
      );
    }

    final provider = context.watch<PatientProvider>();
    final patient = provider.getPatientById(patientId);

    if (patient == null) {
      return Scaffold(
        appBar: StaffAppBar(title: 'Detail Pasien', showBack: true),
        body: const Center(child: Text('Pasien tidak ditemukan')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(title: 'Detail Pasien', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPatientHeader(patient),
            const SizedBox(height: 16),
            _buildInfoSection(patient),
            const SizedBox(height: 16),
            if (patient.symptomHistory.isNotEmpty) ...[
              _buildSymptomHistory(patient),
              const SizedBox(height: 16),
            ],
            if (patient.visitHistory.isNotEmpty) ...[
              _buildVisitHistory(patient),
              const SizedBox(height: 16),
            ],
            _buildActivityTimeline(patient),
            const SizedBox(height: 16),
            AppButton(
              text: 'Update Data Pasien',
              icon: Icons.edit_rounded,
              onPressed: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(PatientModel patient) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryTeal, AppColors.tealMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                patient.initials,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${patient.age} tahun • ${patient.gender}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.gray500,
                  ),
                ),
                const SizedBox(height: 6),
                RiskBadge(riskLevel: patient.riskLevel),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(PatientModel patient) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Pasien',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow(Icons.location_on_rounded, 'Lokasi', patient.location),
          const Divider(height: 20),
          _infoRow(
            Icons.local_hospital_rounded,
            'Puskesmas',
            patient.puskesmas,
          ),
          const Divider(height: 20),
          _infoRow(
            Icons.healing_rounded,
            'Gejala',
            patient.symptom.isNotEmpty ? patient.symptom : 'Tidak ada gejala',
          ),
          const Divider(height: 20),
          _infoRow(
            Icons.update_rounded,
            'Terakhir Update',
            patient.lastUpdateLabel,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryTeal),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.gray500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.gray900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSymptomHistory(PatientModel patient) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Gejala',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          ...patient.symptomHistory.map((record) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: record.severity >= 3
                          ? AppColors.coralPale
                          : AppColors.tealPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.thermostat_rounded,
                      size: 16,
                      color: record.severity >= 3
                          ? AppColors.coral
                          : AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.symptom,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(record.date),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: record.severity >= 3
                          ? AppColors.coralPale
                          : AppColors.tealPale,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Level ${record.severity}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: record.severity >= 3
                            ? AppColors.coral
                            : AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVisitHistory(PatientModel patient) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Riwayat Kunjungan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          ...patient.visitHistory.map((record) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.tealPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.local_hospital_rounded,
                      size: 16,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.diagnosis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${record.puskesmas} • ${_formatDate(record.date)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ),
                        if (record.notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            record.notes,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.gray700,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline(PatientModel patient) {
    final activities = <_Activity>[];
    for (final s in patient.symptomHistory) {
      activities.add(_Activity(
        date: s.date,
        title: s.symptom,
        subtitle: 'Gejala terdeteksi',
        icon: Icons.thermostat_rounded,
        color: s.severity >= 3 ? AppColors.coral : AppColors.primaryTeal,
        bgColor: s.severity >= 3 ? AppColors.coralPale : AppColors.tealPale,
      ));
    }
    for (final v in patient.visitHistory) {
      activities.add(_Activity(
        date: v.date,
        title: v.diagnosis,
        subtitle: 'Kunjungan ke ${v.puskesmas}',
        icon: Icons.local_hospital_rounded,
        color: AppColors.primaryTeal,
        bgColor: AppColors.tealPale,
      ));
    }
    activities.sort((a, b) => b.date.compareTo(a.date));

    if (activities.isEmpty) {
      return const AppCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Belum ada aktivitas',
              style: TextStyle(color: AppColors.gray500),
            ),
          ),
        ),
      );
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aktivitas Terkini',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          ...activities.map((activity) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: activity.bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          activity.icon,
                          size: 16,
                          color: activity.color,
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 24,
                        color: AppColors.gray200,
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activity.subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.gray500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDateTime(activity.date),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.gray300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
  }
}

class _Activity {
  final DateTime date;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bgColor;

  _Activity({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

