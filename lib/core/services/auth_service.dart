import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AuthService extends ChangeNotifier {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _isLoggedIn = false;
  UserProfile? _user;

  bool get isLoggedIn => _isLoggedIn;
  UserProfile? get user => _user;

  static const UserProfile _defaultUser = UserProfile(
    id: 'u1',
    name: 'Inusah Ibraheem',
    email: 'inusah@foodiego.com',
    phone: '+1 (555) 123-4567',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    address: '123 Food Street, Culinary City, FC 10001',
    totalOrders: 47,
    favoriteCount: 12,
  );

  Future<bool> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (email.isNotEmpty && password.length >= 4) {
      _isLoggedIn = true;
      _user = _defaultUser;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }

  void restoreSession() {
    _isLoggedIn = true;
    _user = _defaultUser;
    notifyListeners();
  }
}
