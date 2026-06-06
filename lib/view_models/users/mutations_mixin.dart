import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';
import 'package:sistema_escolar_bnl/view_models/users/users_vm.dart';

mixin MutationsMixin on UsersBaseVm {
  MutationCommonParams<C, S> _params<C extends Function, S extends Function>(
    BuildContext context,
    C cb,
  ) => MutationCommonParams<C, S>(
    context,
    cb: cb,
    timestamped: true,
    queryKey: kUsersQueryKey,
    getStateManager: getStateManager,
    successName: 'usuario',
    unauthPluralName: 'usuarios',
    successMsgVocal: 'o',
  );

  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(_params(context, repository.deleteUser));

  SingleUpdateMutation createChangeRoleMutation(BuildContext context) =>
      createSingleUpdateMutation<UserRole>(
        _params(context, (id, role) => repository.changeRole(role, id)),
        propName: UsersTableColumns.role.name,
        getValue: (event, ctx) =>
            UserRole.values.firstWhere((role) => role.label == event.value),
      );
}
