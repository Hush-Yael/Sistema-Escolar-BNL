import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/navigation/router.dart';
import 'package:sistema_escolar_bnl/core/setup_page.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:sistema_escolar_bnl/core/theme/theme_mode.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final initialization = Future(() async {
    Intl.defaultLocale = 'es_VE';

    await WindowManager.instance.ensureInitialized();

    await Future.wait([
      initializeDateFormatting(),

      WindowManager.instance.setTitle(
        "Sistema de Control Estudiantil - Bicentenario Natalicio del Libertador",
      ),

      SharedPrefsService.setup(),
    ]);
  });

  runApp(SetupPage(app: MyApp(), initialization: initialization));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = ThemeModeState.instance.of(context);

    return SignalBuilder(
      builder: (context, child) {
        return ShadApp.custom(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode.state.value,
          appBuilder: (context) {
            return MaterialApp.router(
              theme: Theme.of(context),
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                GlobalShadLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              routerConfig: AppRouter(
                authState: AuthState.instance.of(context),
              ).config,
              builder: (context, child) => ShadAppBuilder(child: child),
            );
          },
        );
      },
    );
  }
}
