class StaffModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String puskesmas;
  final String phone;
  final String? photoUrl;

  StaffModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.puskesmas,
    required this.phone,
    this.photoUrl,
  });

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
