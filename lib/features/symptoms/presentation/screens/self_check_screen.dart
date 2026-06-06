import 'package:flutter/material.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:respiro/core/widgets/public_drawer.dart';
import 'package:respiro/core/constants/app_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelfCheckScreen extends StatefulWidget {
  const SelfCheckScreen({super.key});

  @override
  State<SelfCheckScreen> createState() => _SelfCheckScreenState();
}

class _SelfCheckScreenState extends State<SelfCheckScreen> {
  String _selectedLocation = 'Kampus';
  int _durationHours = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray100,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text(
          'Respiro',
          style: AppTypography.h2.copyWith(color: AppColors.primaryTeal),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.tealPale,
              child: const Icon(Icons.person, color: AppColors.primaryTeal, size: 20),
            ),
          ),
        ],
      ),
      drawer: const PublicDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Catatan Aktivitas Harian', style: AppTypography.h2),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.gray500),
                const SizedBox(width: 4),
                Text('Selasa, 24 Oktober 2023', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lokasi Aktivitas', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Kampus', 'Kantor', 'Perpus', 'Rumah', 'Lainnya'].map((location) {
                      return ChoiceChip(
                        label: Text(location),
                        selected: _selectedLocation == location,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedLocation = location);
                          }
                        },
                        selectedColor: AppColors.primaryTeal,
                        labelStyle: AppTypography.caption.copyWith(
                          color: _selectedLocation == location ? AppColors.white : AppColors.gray700,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: AppColors.gray100,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: _selectedLocation == location ? AppColors.primaryTeal : Colors.transparent),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Durasi Berada di Lokasi', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                      Text('Jam', style: AppTypography.caption.copyWith(color: AppColors.gray400)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCounterRow(
                    value: _durationHours,
                    onDecrement: () {
                      if (_durationHours > 1) setState(() => _durationHours--);
                    },
                    onIncrement: () {
                      if (_durationHours < 24) setState(() => _durationHours++);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        try {
                          final user = Supabase.instance.client.auth.currentUser;
                          if (user == null) throw Exception('Silakan login terlebih dahulu');
                          
                          await Supabase.instance.client.from('activities').insert({
                            'user_id': user.id,
                            'location': _selectedLocation,
                            'duration_hours': _durationHours,
                            'notes': 'Dicatat pada ${DateTime.now().toString().split('.')[0]}',
                          });
                          
                          if (mounted) {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Catatan berhasil disimpan!'),
                                backgroundColor: AppColors.primaryTeal,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            setState(() => _isLoading = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coral),
                            );
                          }
                        }
                      },
                      icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.save_outlined, color: AppColors.white, size: 20),
                      label: _isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                          : Text('Simpan Catatan', style: AppTypography.button.copyWith(color: AppColors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Riwayat Catatan', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildHistoryCard(
              date: 'OKT\n23',
              location: 'Kampus',
              durationHours: 4,
              notes: 'Tugas kelompok di area merokok, udara terasa pengap.',
            ),
            const SizedBox(height: 12),
            _buildHistoryCard(
              date: 'OKT\n22',
              location: 'Kantor',
              durationHours: 8,
              notes: 'Bekerja seharian, memakai masker saat di luar.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow({required int value, required VoidCallback onDecrement, required VoidCallback onIncrement}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove, color: AppColors.primaryTeal),
          ),
          Text(
            value.toString(),
            style: AppTypography.h2,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard({required String date, required String location, required int durationHours, required String notes}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gray700),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.coral),
                        const SizedBox(width: 4),
                        Text(location, style: AppTypography.caption.copyWith(color: AppColors.coral, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: AppColors.primaryTeal),
                        const SizedBox(width: 4),
                        Text('Durasi: $durationHours Jam', style: AppTypography.caption.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(notes, style: AppTypography.caption.copyWith(color: AppColors.gray500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
