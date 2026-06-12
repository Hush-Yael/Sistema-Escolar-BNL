import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  SharedPrefsService();

  static final instance = Provider((context) => SharedPrefsService());

  static SharedPreferences? service;

  /// Ensures the service is initialized, must be called before using the instance
  static Future<void> setup() async {
    service ??= await SharedPreferences.getInstance();
  }

  static const themeModeKey = 'theme';

  String getStoredThemeMode() {
    return service!.getString(themeModeKey) ?? ThemeMode.system.name;
  }

  Future<bool> saveThemeMode(ThemeMode newMode) async {
    return await service!.setString(themeModeKey, newMode.name);
  }

  bool getSidebarExpanded() {
    return service!.getBool('sidebar_expanded') ?? true;
  }

  Future<bool> saveSidebarExpanded(bool expanded) async {
    return await service!.setBool('sidebar_expanded', expanded);
  }
}
