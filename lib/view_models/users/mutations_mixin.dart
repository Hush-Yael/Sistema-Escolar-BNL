import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';
import 'package:sistema_escolar_bnl/view_models/users/users_vm.dart';

mixin MutationsMixin on UsersBaseVm {
  MutationCommonParams<S> _params<S extends Function>(BuildContext context) =>
      MutationCommonParams<S>(
        context,
        timestamped: true,
        queryKey: kUsersQueryKey,
        getStateManager: getStateManager,
        successName: 'usuario',
        unauthPluralName: 'usuarios',
        successMsgVocal: 'o',
      );

  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        .fromCommonParams(_params(context), repository.deleteUser),
      );

  SingleUpdateMutation createUpdateMutation(BuildContext context) =>
      createSingleUpdateMutation(
        _params(context),
        cb: (column, id, value) => repository.changeRole(id, value),
        getValue: (event, ctx) =>
            UserRole.values.firstWhere((role) => role.label == event.value),
      );
}
