import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';

void autoLogin(BuildContext context) {
  final db = AppDatabase.instance.of(context);

  (db.users.select()..where((t) => t.username.equals('admin')))
      .getSingleOrNull()
      .then((user) {
        if (user != null) AuthState.instance.setUser(user);
      });
}
