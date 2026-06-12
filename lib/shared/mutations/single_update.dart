import 'package:flutter_query/flutter_query.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:trina_grid/trina_grid.dart';

typedef SingleUpdateMutation =
    MutationResult<int, dynamic, TrinaGridOnChangedEvent, DateTime?>;

typedef SingleUpdateMutationCb<T> =
    Future<int> Function(String column, int id, T newValue);

typedef SingleUpdateMutationSideEffect =
    void Function(TrinaGridOnChangedEvent event, MutationFunctionContext ctx)?;

/// Handles an update mutation for a single model object.
/// It checks update permission before updating.
/// On error, it reverts the changes.
/// On success, the object list is refetch.
/// [propName] is the name of the property to update.
SingleUpdateMutation createSingleUpdateMutation<T>(
  /// [getValue] is a function that returns the new value to update. If not provided, it will use the event value.
  MutationCommonParams<SingleUpdateMutationSideEffect> params, {
  required SingleUpdateMutationCb<T> cb,
  T Function(TrinaGridOnChangedEvent event, MutationFunctionContext ctx)?
  getValue,
}) {
  assert(params.getStateManager != null);

  return useMutation(
    (event, ctx) async {
      if (!AuthState.isAtLeast(.operator)) {
        return Future.error(
          'No tienes permiso para editar ${params.unauthPluralName}',
        );
      }

      final int id = event.row.$id;
      final newValue = getValue?.call(event, ctx) ?? event.value;

      // return await Future.error('error');
      return await cb(event.column.field, id, newValue);
    },

    onMutate: (event, ctx) {
      // important! prevents crashing
      params.getStateManager!()?.setEditing(false);

      params.onMutate?.call(event, ctx);
      return null;
    },

    onError: (error, event, previousUpdatedAt, ctx) {
      toast(
        context: params.context,
        message: error.toString(),
        destructive: true,
      );

      try {
        event.cell.value = event.oldValue;

        params.onError?.call(event, ctx);
      } catch (e) {
        print(e);
      }
    },

    onSuccess: (_, event, _, ctx) {
      toast(
        context: params.context,
        message:
            '${toBeginningOfSentenceCase(params.successName)} actualizad${params.successMsgVocal}',
      );

      ctx.client.invalidateQueries(queryKey: params.queryKey);

      params.onSuccess?.call(event, ctx);
    },
  );
}
