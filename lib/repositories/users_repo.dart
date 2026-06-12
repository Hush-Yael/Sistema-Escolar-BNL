import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';

class UsersRepository extends Repository {
  const UsersRepository(super.db);

  @override
  get table => db.users;

  Future<List<User>> getUsers(OrderTerms terms) async =>
      await (db.select(db.users)..orderBy(buildOrder(terms))).get();

  final companion = UsersCompanion.new;

  Future<int> deleteUser(int id) async =>
      await deleteSingle(id, companion, 'No se pudo eliminar el usuario');

  Future<int> changeRole(int id, UserRole role) async => await updateSingle(
    id,
    companion,
    UsersCompanion(role: Value(role)),
    defaultFailMsg: 'No se pudo cambiar el rol',
  );
}
