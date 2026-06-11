import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/buttons.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/users/users_vm.dart';
import 'package:trina_grid/trina_grid.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(providers: [UsersVm.instance], child: const _Table());
  }
}

class _Table extends HookWidget {
  const _Table();

  @override
  Widget build(BuildContext context) {
    final vm = UsersVm.instance.of(context);

    final selfId = AuthState.instance.user?.id;

    final deleteMutation = vm.createDeleteMutation(context);
    final updateMutation = vm.createUpdateMutation(context);

    return QueryTable(
      queryKey: kUsersQueryKey,
      queryFn: vm.repository.getUsers,
      pluralModelArticle: 'los',
      pluralModelName: 'usuarios',
      getCells: (user) => {
        UsersTableColumns.name.name: TrinaCell(value: user.name),

        UsersTableColumns.username.name: TrinaCell(value: user.username),

        UsersTableColumns.role.name: TrinaCell(value: user.role.label),

        UsersTableColumns.lastLogin.name: TrinaCell(value: user.lastLogin),
      },
      setStateManager: vm.setStateManager,
      deleteMutation: deleteMutation,
      onLoaded: (e) => e.stateManager.setShowColumnFilter(true),
      onBeforeActiveCellChange: (e) => e.newCell.row.$id != selfId,
      onChanged: updateMutation.mutate,
      actionsRenderer: (ctx) {
        final userId = ctx.row.$id;

        return Center(
          child: (userId == AuthState.instance.user?.id)
              ? const ShadBadge(
                  child: Text(
                    'Tú',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                )
              : DeleteBtn(
                  ctx: ctx,
                  deleteMutation: deleteMutation,
                  title: '¿Realmente quieres eliminar este usuario?',
                ),
        );
      },
      getColumns: (context) => [
        TableColumn.text(UsersTableColumns.name, editable: false),

        TableColumn.text(UsersTableColumns.username, editable: false),

        TableColumn(
          UsersTableColumns.role,
          type: .select(UserRole.values.map((role) => role.label).toList()),
        ),

        TableColumn.date(UsersTableColumns.lastLogin, editable: false),
      ],
    );
  }
}
