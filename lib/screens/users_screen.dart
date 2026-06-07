import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/constants/auth_constants.dart';
import 'package:sistema_escolar_bnl/constants/users_constants.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
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
    final changeRoleMutation = vm.createChangeRoleMutation(context);

    return QueryTable(
      queryKey: kUsersQueryKey,
      queryFn: vm.getUsers,
      errorTitle: 'Error al cargar usuarios',
      getRows: vm.getRows,
      setStateManager: vm.setStateManager,
      deleteMutation: deleteMutation,
      createConfig: (baseConfig) => baseConfig.copyWith(selectingMode: .none),
      onLoaded: (e) => e.stateManager.setShowColumnFilter(true),
      onBeforeActiveCellChange: (e) => e.newCell.row.$id != selfId,
      onChanged: (event) {
        final field = UsersTableColumns.values.byName(event.column.field);

        if (field == UsersTableColumns.role) changeRoleMutation.mutate(event);
      },
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
              : ShadIconButton.destructive(
                  height: 30,
                  width: 30,
                  iconSize: 20,
                  onPressed: () {
                    confirmDeletion(
                      context,
                      title: '¿Realmente quieres eliminar este usuario?',
                      msg: 'Esta acción no se puede deshacer.',
                      onConfirmed: () => deleteMutation.mutate(ctx),
                    );
                  },
                  icon: const Icon(Icons.delete_outline_outlined),
                ),
        );
      },
      getColumns: (context) => [
        .new(
          field: UsersTableColumns.name.name,
          type: .text(),
          title: 'Nombre',
          enableEditingMode: false,
        ),

        .new(
          field: UsersTableColumns.username.name,
          type: .text(),
          title: 'Nombre de usuario',
          enableEditingMode: false,
        ),

        .new(
          field: UsersTableColumns.role.name,
          type: .select(UserRole.values.map((role) => role.label).toList()),
          title: 'Rol',
        ),

        .new(
          field: UsersTableColumns.lastLogin.name,
          type: formattedDateColumnType,
          title: 'Último ingreso',
          enableEditingMode: false,
        ),
      ],
    );
  }
}
