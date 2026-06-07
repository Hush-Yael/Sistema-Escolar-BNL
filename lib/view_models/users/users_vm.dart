import 'package:collection/collection.dart';
import 'package:disco/disco.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/repositories/users_repo.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/mixin.dart';
import 'package:sistema_escolar_bnl/types/users_types.dart';
import 'package:sistema_escolar_bnl/view_models/users/mutations_mixin.dart';
import 'package:trina_grid/trina_grid.dart';
// import 'package:sistema_escolar_bnl/view_models/users/users_delete_mixin.dart';
// import 'package:sistema_escolar_bnl/view_models/users/users_table_mixin.dart';
// import 'package:sistema_escolar_bnl/view_models/users/users_change_role_mixin.dart';

class UsersBaseVm with VmTrinaGridMixin {
  final UsersRepository repository;
  final AuthState authState = .instance;

  UsersBaseVm({required this.repository});

  late final Future<UsersList> Function() getUsers = repository.fetchUsers;

  List<TrinaRow> getRows(UsersList usersList) =>
      usersList.mapIndexed((rowIndex, user) {
        return TrinaRow(
          metadata: {'id': user.id},
          cells: {
            kIndexColumnField: TrinaCell(value: rowIndex + 1),

            UsersTableColumns.name.name: TrinaCell(value: user.name),

            UsersTableColumns.username.name: TrinaCell(value: user.username),

            UsersTableColumns.role.name: TrinaCell(value: user.role.label),

            UsersTableColumns.lastLogin.name: TrinaCell(value: user.lastLogin),
          },
        );
      }).toList();
}

class UsersVm extends UsersBaseVm with MutationsMixin {
  UsersVm({required super.repository});

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final usersRepository = UsersRepository(db);

    return UsersVm(repository: usersRepository);
  });
}
