import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppTheme {
  const AppTheme._();

  // Base theme configuration (used by both light and dark themes)
  static ShadThemeData _extendBaseTheme(ShadThemeData t) {
    return t.copyWith(
      inputTheme: t.inputTheme.copyWith(
        decoration: t.inputTheme.decoration?.copyWith(
          color: t.cardTheme.backgroundColor,
        ),
      ),

      selectTheme: t.selectTheme.copyWith(
        decoration: t.selectTheme.decoration?.copyWith(
          color: t.cardTheme.backgroundColor,
        ),
      ),
    );
  }

  static final ShadThemeData lightTheme = _extendBaseTheme(
    ShadThemeData(brightness: Brightness.light),
  );

  static final ShadThemeData darkTheme = _extendBaseTheme(
    ShadThemeData(brightness: Brightness.dark),
  );

  /// When input is invalid, use this style for labels instead of the default, since the latter uses the same color as error color
  static TextStyle labelStyles(BuildContext context) =>
      TextStyle(color: ShadTheme.of(context).colorScheme.foreground);
}

extension AppThemeExtension on BuildContext {
  ShadThemeData get theme => ShadTheme.of(this);
}
