import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:respiro/core/widgets/app_card.dart';
import 'package:respiro/core/widgets/app_button.dart';
import 'package:respiro/core/widgets/app_input.dart';
import 'package:respiro/features/staff/widgets/staff_app_bar.dart';
import 'package:respiro/features/staff/providers/patient_provider.dart';
import 'package:respiro/features/staff/models/patient_model.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _symptomController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedGender = 'Laki-laki';
  String _selectedRisk = 'Low';
  String _selectedPuskesmas = 'Puskesmas Pusat';
  bool _isSaving = false;

  final _genders = ['Laki-laki', 'Perempuan'];
  final _riskLevels = ['Low', 'Medium', 'High'];
  final _puskesmasList = [
    'Puskesmas Pusat',
    'Puskesmas Utara',
    'Puskesmas Selatan',
    'Puskesmas Timur',
    'Puskesmas Barat',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _symptomController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: StaffAppBar(title: 'Tambah Pasien', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormSection(
                title: 'Data Pribadi',
                children: [
                  AppInput(
                    label: 'Nama Lengkap',
                    hint: 'Masukkan nama pasien',
                    controller: _nameController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppInput(
                          label: 'Usia',
                          hint: 'Tahun',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Usia wajib diisi';
                            final age = int.tryParse(v);
                            if (age == null || age < 0 || age > 150) {
                              return 'Usia tidak valid';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDropdown(
                          label: 'Jenis Kelamin',
                          value: _selectedGender,
                          items: _genders,
                          onChanged: (v) =>
                              setState(() => _selectedGender = v!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormSection(
                title: 'Data Medis',
                children: [
                  _buildDropdown(
                    label: 'Tingkat Risiko',
                    value: _selectedRisk,
                    items: _riskLevels,
                    onChanged: (v) => setState(() => _selectedRisk = v!),
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'Gejala',
                    hint: 'Masukkan gejala yang dialami',
                    controller: _symptomController,
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildFormSection(
                title: 'Lokasi & Fasilitas',
                children: [
                  _buildDropdown(
                    label: 'Puskesmas',
                    value: _selectedPuskesmas,
                    items: _puskesmasList,
                    onChanged: (v) =>
                        setState(() => _selectedPuskesmas = v!),
                  ),
                  const SizedBox(height: 16),
                  AppInput(
                    label: 'Alamat',
                    hint: 'Masukkan alamat lengkap',
                    controller: _locationController,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Alamat wajib diisi' : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Simpan Pasien',
                isLoading: _isSaving,
                icon: Icons.save_rounded,
                onPressed: _savePatient,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.gray700,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppConstants.inputRadius),
            border: Border.all(color: AppColors.gray200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.gray500,
              ),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.gray900,
              ),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _savePatient() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newPatient = PatientModel(
      id: 'P${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      gender: _selectedGender,
      symptom: _symptomController.text.trim(),
      riskLevel: _selectedRisk,
      location: _locationController.text.trim(),
      puskesmas: _selectedPuskesmas,
      lastUpdate: DateTime.now(),
    );

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      context.read<PatientProvider>().addPatient(newPatient);
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pasien berhasil ditambahkan'),
          backgroundColor: AppColors.primaryTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      context.pop();
    });
  }
}
