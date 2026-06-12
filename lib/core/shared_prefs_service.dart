import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trina_grid/trina_grid.dart';

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

  static String _keyForColPinned(String field) => '$field-pinned';

  static TrinaColumnFrozen getColPinState(String field) {
    return TrinaColumnFrozen.values.byName(
      service!.getString(_keyForColPinned(field)) ??
          TrinaColumnFrozen.none.name,
    );
  }

  Future<bool> setColPinState(String field, TrinaColumnFrozen pinState) async {
    if (pinState == TrinaColumnFrozen.none) {
      return await service!.remove(_keyForColPinned(field));
    }

    return await service!.setString(_keyForColPinned(field), pinState.name);
  }

  static String _keyForColHidden(String field) => '$field-hidden';

  static bool getColHideState(String field) {
    return service!.getBool(_keyForColHidden(field)) ?? false;
  }

  Future<bool> setColHideState(String field, bool hide) async {
    if (!hide) return await service!.remove(_keyForColHidden(field));

    return await service!.setBool(_keyForColHidden(field), hide);
  }

  String _keyForSortMode(String field) => '$field-order';

  OrderingMode? getColSortMode(String field) {
    final mode = service!.getString(_keyForSortMode(field));
    if (mode == null) return null;
    return OrderingMode.values.byName(mode);
  }

  Future<bool> setColOrderMode(String field, OrderingMode? mode) async {
    if (mode == null) return await service!.remove(_keyForSortMode(field));

    return await service!.setString(_keyForSortMode(field), mode.name);
  }
}
