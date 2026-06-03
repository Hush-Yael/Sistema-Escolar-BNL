// ignore_for_file: avoid_print

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/db/seed.dart';

/// Used to recreate the database applying changes without migrations in dev mode
class WithResetBtn extends StatelessWidget {
  final Widget widget;

  const WithResetBtn({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget,

        Positioned(
          bottom: 0,
          right: 0,
          child: ShadButton(
            onPressed: () async {
              final db = AppDatabase.instance.of(context);
              final m = drift.Migrator(db);
              final tables = db.allTables;

              print('Resetting database...');

              // Disable foreign key constraints to avoid errors
              await db.customStatement('PRAGMA foreign_keys = OFF');

              await Future.wait(
                tables.map(
                  (table) => m
                      .deleteTable(table.actualTableName)
                      .then(
                        (value) => m
                            .createTable(table)
                            .then((value) => db.markTablesUpdated({table})),
                      ),
                ),
              );

              print('Database was reset successfully. Seeding...');

              await db.customStatement('PRAGMA foreign_keys = ON');
              await seed(db);

              print('Database seeded successfully.');
            },
            child: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
