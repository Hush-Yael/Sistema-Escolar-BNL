import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/models/auth_models.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'db.g.dart';

@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      /* beforeOpen: (details) async {
        // Enable foreign keys immediately upon opening the database
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated && kDebugMode) await seed(this);
      }, */
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: kReleaseMode
          ? const DriftNativeOptions(
              databaseDirectory: getApplicationSupportDirectory,
            )
          : DriftNativeOptions(
              databasePath: () async {
                final directory = Directory.current.path;

                return p.join(directory, 'lib', 'core', 'db', 'dev.db');
              },
            ),
    );
  }

  static final instance = Provider((context) => AppDatabase());
}
