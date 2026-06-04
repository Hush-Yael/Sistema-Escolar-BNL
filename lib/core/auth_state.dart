import 'package:disco/disco.dart';
import 'package:flutter/foundation.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';

class AuthState extends ChangeNotifier {
  AuthState._internal();

  User? _user /*  = User(
    id: 1,
    name: 'Administrador',
    username: 'admin',
    role: UserRole.admin,
    password: '',
    salt: '',
    createdAt: DateTime.now(),
  ) */;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool isAuthenticated() => _user != null;

  static final instance = AuthState._internal();

  static final provide = Provider((context) => instance);
}
