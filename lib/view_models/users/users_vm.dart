import 'package:disco/disco.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/repositories/users_repo.dart';
import 'package:sistema_escolar_bnl/shared/table/table_vm.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';

class UsersVm extends TableVm {
  @override
  final UsersRepository repository;

  final AuthState authState = .instance;

  UsersVm(
    this.repository, {
    super.queryKey = kUsersQueryKey,
    super.mutSuccessName = 'usuario',
    super.mutUnauthPluralName = 'usuarios',
    super.mutSuccessMsgVocal = 'o',
  });

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final usersRepository = UsersRepository(db);

    return UsersVm(usersRepository);
  });

  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        .fromCommonParams(mutParams(context), repository.deleteUser),
      );

  SingleUpdateMutation createUpdateMutation(BuildContext context) =>
      createSingleUpdateMutation(
        mutParams(context),
        cb: (column, id, value) => repository.changeRole(id, value),
        getValue: (event, ctx) =>
            UserRole.values.firstWhere((role) => role.label == event.value),
      );
}
