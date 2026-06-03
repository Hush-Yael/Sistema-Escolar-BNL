import 'package:disco/disco.dart';
import 'package:flutter/widgets.dart';
import 'package:fquery/fquery.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:sistema_escolar_bnl/core/theme/theme_mode.dart';
import 'package:window_manager/window_manager.dart';

class SetupPage extends StatefulWidget {
  final Widget app;
  const SetupPage({super.key, required this.app});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  late final initialization = Future(() async {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError) {
          return Error(snapshot: snapshot);
        }

        return CacheProvider(
          cache: .new(),
          child: ProviderScope(
            providers: [
              SharedPrefsService.instance,
              ThemeModeState.instance,
              AppDatabase.instance,
              AuthState.instance,
            ],
            child: widget.app,
          ),
        );
      },
    );
  }
}

class Error extends StatelessWidget {
  final AsyncSnapshot snapshot;

  const Error({super.key, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: Text('Error: ${snapshot.error}')),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200, height: 8, child: const ShadProgress()),

            Text(
              'Iniciando, por favor espere...',
              style: AppTheme.lightTheme.textTheme.h4,
            ),
          ],
        ),
      ),
    );
  }
}
