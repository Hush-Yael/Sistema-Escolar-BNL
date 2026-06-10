import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:meta/meta.dart';

/// All the services used in the app must have a db dependency
class Repository<TT extends Table, DC extends DataClass> {
  @protected
  final AppDatabase db;

  @protected
  @mustBeOverridden
  TableInfo<TT, DC> get table =>
      throw UnimplementedError('Se debe indicar la tabla a usar');

  const Repository(this.db);

  static const int uniqueConflict = 2067;
  static const int foreignConstraint = 1811;

  @protected
  /// Update and delete operations must return at least 1 row to be considered successful
  Future<int> ensureMutated(Future<int> operation, String failedMsg) async {
    final int count = await operation;

    if (count > 0) {
      return count;
    } else {
      throw Exception(failedMsg);
    }
  }

  @protected
  /// expect that, if db operation fails, an error that explains what went wrong should be thrown
  Future<T> expectDBError<T>(
    Future<T> operation,
    String defaultMsg, {
    String? Function(SqliteException error)? onSqliteException,
  }) async {
    try {
      return await operation;
    } catch (e) {
      if (e is DriftRemoteException) {
        final cause = e.remoteCause;

        if (cause is SqliteException && onSqliteException != null) {
          final msg = onSqliteException(cause);
          if (msg != null) throw msg;
        }
      }

      throw Exception(defaultMsg);
    }
  }

  @protected
  Future<int> updateSingle(
    int id,
    CompanionWithId constructorWithId,
    Insertable<DC> companion, {
    required String defaultFailMsg,
    String? uniqueFailMsg,
  }) async {
    final op =
        (table.update()..whereSamePrimaryKey(constructorWithId(id: Value(id))))
            .write(companion);

    return await expectDBError(
      ensureMutated(op, defaultFailMsg),
      defaultFailMsg,
      onSqliteException: (error) => error.extendedResultCode == uniqueConflict
          ? uniqueFailMsg ?? 'Se esperaba un valor único'
          : null,
    );
  }

  @protected
  Future<int> deleteSingle<T extends CompanionWithId>(
    int id,
    T modelCompanion,
    String failedMsg,
  ) async {
    final op = delay(
      (db.delete(
        table,
      )..whereSamePrimaryKey(modelCompanion(id: Value(id)))).go(),
    );

    return await ensureMutated(op, failedMsg);
  }

  @protected
  Future<bool> checkFieldValueAvailable(
    Expression<bool> Function(TT) filter,
  ) async {
    final product =
        await (table.select()
              ..limit(1)
              ..where(filter))
            .getSingleOrNull();

    return product != null;
  }
}

typedef CompanionWithId = Function({required Value<int> id});
