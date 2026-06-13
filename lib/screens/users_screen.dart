import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/buttons.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:sistema_escolar_bnl/view_models/users/users_vm.dart';

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

    return QueryTable<User, Exception>(
      queryKey: kUsersQueryKey,
      queryFn: vm.repository.getUsers,
      pluralModelArticle: 'los',
      pluralModelName: 'usuarios',
      setStateManager: vm.setStateManager,
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
        .text(
          UsersTableColumns.name,
          editable: false,
          getCellValue: (user) => user.name,
        ),

        .text(
          UsersTableColumns.username,
          editable: false,
          getCellValue: (user) => user.username,
        ),

        TableColumn(
          UsersTableColumns.role,
          type: .select(UserRole.values.map((role) => role.label).toList()),
          getCellValue: (user) => user.role.label,
        ),

        .date(
          UsersTableColumns.lastLogin,
          editable: false,
          getCellValue: (user) => user.lastLogin,
        ),
      ],
    );
  }
}
