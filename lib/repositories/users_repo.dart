import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/services_repository.dart';
import 'package:sistema_escolar_bnl/types/users_types.dart';

class UsersRepository extends ServiceRepository {
  const UsersRepository(super.db, {required super.table});

  Future<UsersList> fetchUsers() async =>
      await delay((db.select(db.users)).get());

  final companion = UsersCompanion.new;

  Future<int> deleteUser(int id) async =>
      await delete(id, companion, 'No se pudo eliminar el usuario');

  Future<int> changeRole(UserRole role, int id) async => await update(
    id,
    companion,
    UsersCompanion(role: Value(role)),
    defaultFailMsg: 'No se pudo cambiar el rol',
  );
}
