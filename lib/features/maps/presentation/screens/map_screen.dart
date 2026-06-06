import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:respiro/core/theme/app_colors.dart';
import 'package:respiro/core/theme/app_typography.dart';
import 'package:go_router/go_router.dart';
import 'package:respiro/core/widgets/public_drawer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MapScreen extends StatefulWidget {
  final double? targetLat;
  final double? targetLng;
  final String? targetTitle;

  const MapScreen({super.key, this.targetLat, this.targetLng, this.targetTitle});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  
  late LatLng _center;
  String? _markerTitle;

  List<Map<String, dynamic>> _riskZones = [];
  Map<String, dynamic>? _selectedZone;
  bool _isLoadingMapData = true;

  // Koordinat dummy untuk mapping teks lokasi
  final Map<String, LatLng> _locationCoords = {
    'Kampus': const LatLng(-7.279, 112.790), // Area ITS/Unair
    'Kantor': const LatLng(-7.265, 112.750), // Pusat Surabaya
    'Perpus': const LatLng(-7.280, 112.795), 
    'Rumah': const LatLng(-7.300, 112.740),
  };

  @override
  void initState() {
    super.initState();
    _center = (widget.targetLat != null && widget.targetLng != null)
        ? LatLng(widget.targetLat!, widget.targetLng!)
        : const LatLng(-7.279, 112.790);
    _markerTitle = widget.targetTitle;

    if (widget.targetLat != null && widget.targetLng != null) {
      _selectedZone = {
        'location': widget.targetTitle ?? 'Fasilitas',
        'count': 0,
        'status': 'Fasilitas Medis',
        'color': AppColors.primaryTeal,
        'coord': _center,
        'isFacility': true,
      };
    }

    _fetchActivityData();
  }

  Future<void> _fetchActivityData() async {
    try {
      final data = await Supabase.instance.client.from('activities').select();
      
      final Map<String, int> locationCounts = {};
      for (var row in data) {
        final loc = row['location'] as String;
        locationCounts[loc] = (locationCounts[loc] ?? 0) + 1;
      }

      final List<Map<String, dynamic>> zones = [];
      locationCounts.forEach((loc, count) {
        LatLng? coord = _locationCoords[loc];
        if (coord == null) {
          final hash = loc.hashCode;
          final latOffset = (hash % 100) / 10000.0 - 0.005;
          final lngOffset = ((hash ~/ 100) % 100) / 10000.0 - 0.005;
          coord = LatLng(-7.279 + latOffset, 112.790 + lngOffset);
        }

        String status = 'Aman';
        Color color = AppColors.primaryTeal;
        if (count >= 4) {
          status = 'Rawan TBC';
          color = AppColors.coral;
        } else if (count >= 2) {
          status = 'Waspada';
          color = AppColors.amber;
        }

        zones.add({
          'location': loc,
          'count': count,
          'status': status,
          'color': color,
          'coord': coord,
          'isFacility': false,
        });
      });

      if (mounted) {
        setState(() {
          _riskZones = zones;
          _isLoadingMapData = false;
          
          if (widget.targetLat == null && zones.isNotEmpty) {
            zones.sort((a, b) => b['count'].compareTo(a['count']));
            _selectedZone = zones.first;
            _center = zones.first['coord'];
            _markerTitle = zones.first['location'];
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController.move(_center, 14.0);
            });
          }
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingMapData = false);
    }
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.targetLat != null && widget.targetLng != null && 
        (widget.targetLat != oldWidget.targetLat || widget.targetLng != oldWidget.targetLng)) {
      final newPos = LatLng(widget.targetLat!, widget.targetLng!);
      setState(() {
        _center = newPos;
        _markerTitle = widget.targetTitle;
        _selectedZone = {
          'location': widget.targetTitle ?? 'Fasilitas',
          'count': 0,
          'status': 'Fasilitas Medis',
          'color': AppColors.primaryTeal,
          'coord': newPos,
          'isFacility': true,
        };
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(newPos, 16.0);
      });
    }
  }

  void _moveToCurrentLocation() {
    _mapController.move(_center, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Interaktif'),
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.gray900,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.primaryTeal),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      drawer: const PublicDrawer(),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.respiro',
              ),
              if (_riskZones.isNotEmpty)
                CircleLayer(
                  circles: _riskZones.where((z) => z['count'] >= 2).map((z) {
                    final color = z['color'] as Color;
                    return CircleMarker(
                      point: z['coord'],
                      color: color.withAlpha(40),
                      borderStrokeWidth: 2,
                      borderColor: color,
                      radius: (z['count'] as int) * 15.0 + 30.0,
                    );
                  }).toList(),
                ),
              MarkerLayer(
                markers: [
                  ..._riskZones.map((zone) {
                    final isSelected = _selectedZone != null && _selectedZone!['location'] == zone['location'];
                    final color = zone['color'] as Color;
                    return Marker(
                      point: zone['coord'],
                      width: 120,
                      height: 90,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedZone = zone;
                            _center = zone['coord'];
                            _markerTitle = zone['location'];
                            _mapController.move(_center, 15.0);
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4, offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: Text(
                                  zone['location'],
                                  style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            Icon(
                              Icons.location_pin,
                              color: color,
                              size: isSelected ? 48 : 36,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (widget.targetLat != null && widget.targetLng != null && !(_selectedZone != null && _selectedZone!['isFacility'] == false))
                    Marker(
                      point: LatLng(widget.targetLat!, widget.targetLng!),
                      width: 120,
                      height: 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4, offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Text(
                              widget.targetTitle ?? 'Fasilitas',
                              style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Icon(
                            Icons.local_hospital,
                            color: AppColors.primaryTeal,
                            size: 48,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: _buildMapInfoCard(),
          ),
          Positioned(
            right: 16,
            top: 16,
            child: Column(
              children: [
                _buildActionButton(
                  icon: Icons.my_location_rounded,
                  onTap: _moveToCurrentLocation,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.layers_rounded,
                  onTap: _showLayerBottomSheet,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  icon: Icons.tune_rounded,
                  onTap: _showFilterBottomSheet,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapInfoCard() {
    if (_isLoadingMapData) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
      );
    }

    final zone = _selectedZone;
    final title = zone != null ? zone['location'] : 'Pilih Lokasi di Peta';
    final status = zone != null ? zone['status'] : 'Tidak Diketahui';
    final count = zone != null ? zone['count'] : 0;
    final color = zone != null ? zone['color'] : AppColors.gray500;
    final isFacility = zone != null ? zone['isFacility'] ?? false : false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.h2),
                    const SizedBox(height: 4),
                    Text(isFacility ? 'Fasilitas Kesehatan Terpilih' : '$count pengguna pernah beraktivitas di sini', style: AppTypography.caption.copyWith(color: AppColors.gray500)),
                  ],
                ),
              ),
              if (!isFacility)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: (color as Color).withAlpha(30),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      Icon(status == 'Aman' ? Icons.check_circle_rounded : Icons.warning_rounded, color: color, size: 16),
                      const SizedBox(width: 4),
                      Text(status, style: AppTypography.caption.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: isFacility 
                  ? _buildInfoMetric(
                      icon: Icons.local_hospital_rounded,
                      label: 'Layanan TBC',
                      value: 'Tersedia',
                      status: 'Poli Paru & TCM',
                      valueColor: AppColors.primaryTeal,
                    )
                  : _buildInfoMetric(
                      icon: Icons.people_alt_rounded,
                      label: 'Kepadatan',
                      value: count >= 4 ? 'Tinggi' : (count >= 2 ? 'Sedang' : 'Rendah'),
                      status: 'Catatan Aktivitas',
                      valueColor: color as Color,
                    ),
              ),
              Container(width: 1, height: 48, color: AppColors.gray300),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: isFacility
                    ? _buildInfoMetric(
                        icon: Icons.access_time_rounded,
                        label: 'Operasional',
                        value: 'Buka',
                        status: '08:00 - 20:00',
                        valueColor: AppColors.primaryTeal,
                      )
                    : _buildInfoMetric(
                        icon: Icons.coronavirus_rounded,
                        label: 'Risiko TBC',
                        value: status == 'Rawan TBC' ? 'Tinggi' : (status == 'Waspada' ? 'Sedang' : 'Rendah'),
                        status: 'Estimasi Sistem',
                        valueColor: color as Color,
                      ),
                ),
              ),
            ],
          ),
          if (status == 'Rawan TBC') ...[
            const SizedBox(height: 20),
            Text('Rekomendasi Aktivitas', style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gray700)),
            const SizedBox(height: 12),
            _buildRecommendationRow(
              icon: Icons.masks_rounded,
              title: 'Wajib Gunakan Masker N95',
              desc: 'Kawasan ini memiliki kepadatan aktivitas tinggi, risiko penularan TBC meningkat.',
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/facilities'),
              icon: const Icon(Icons.local_hospital_rounded, color: AppColors.white, size: 18),
              label: Text('Cari Puskesmas Terdekat', style: AppTypography.button.copyWith(color: AppColors.white)),
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
    );
  }

  Widget _buildInfoMetric({required IconData icon, required String label, required String value, required String status, required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.gray500),
            const SizedBox(width: 4),
            Expanded(child: Text(label, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 6),
        Text(value, style: AppTypography.h2.copyWith(color: valueColor, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 2),
        Text(status, style: AppTypography.caption.copyWith(color: AppColors.gray700, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildRecommendationRow({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.coral),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.gray900)),
              Text(desc, style: AppTypography.caption.copyWith(color: AppColors.gray500, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: AppColors.primaryTeal, size: 20),
      ),
    );
  }

  void _showLayerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pilih Tampilan Peta', style: AppTypography.h2),
              const SizedBox(height: 24),
              _buildBottomSheetOption(icon: Icons.map_rounded, title: 'Peta Standar', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.satellite_alt_rounded, title: 'Satelit', isSelected: false),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.directions_transit_rounded, title: 'Transportasi Umum', isSelected: false),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter Tampilan', style: AppTypography.h2),
              const SizedBox(height: 24),
              _buildBottomSheetOption(icon: Icons.air_rounded, title: 'Kualitas Udara (AQI)', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.local_hospital_rounded, title: 'Fasilitas Kesehatan Terdekat', isSelected: true),
              const SizedBox(height: 12),
              _buildBottomSheetOption(icon: Icons.thermostat_rounded, title: 'Suhu & Kelembaban', isSelected: false),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({required IconData icon, required String title, required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.tealPale : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? AppColors.primaryTeal : AppColors.gray200),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primaryTeal : AppColors.gray500),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primaryTeal : AppColors.gray900,
              ),
            ),
          ),
          if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal),
        ],
      ),
    );
  }
}
