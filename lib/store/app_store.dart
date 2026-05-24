import 'package:flutter/foundation.dart';

class AppStore extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  String? _userName;
  String? _userEmail;
  String _userRole = 'public';

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String get userRole => _userRole;

  void setAuth({
    required String token,
    required String name,
    required String email,
    required String role,
  }) {
    _token = token;
    _userName = name;
    _userEmail = email;
    _userRole = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userName = null;
    _userEmail = null;
    _userRole = 'public';
    _isAuthenticated = false;
    notifyListeners();
  }
}
