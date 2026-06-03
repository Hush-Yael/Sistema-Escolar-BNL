import 'dart:ui';

import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  const AppTheme._();

  // Base theme configuration (used by both light and dark themes)
  static ShadThemeData _extendBaseTheme(ShadThemeData t) {
    return t.copyWith();
  }

  static final ShadThemeData lightTheme = _extendBaseTheme(
    ShadThemeData(brightness: Brightness.light),
  );

  static final ShadThemeData darkTheme = _extendBaseTheme(
    ShadThemeData(brightness: Brightness.dark),
  );
}
