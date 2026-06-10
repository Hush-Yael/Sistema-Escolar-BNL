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
/// On mutation it updates the date fields if [params.timestamped] is true.
/// On error, it reverts the changes.
/// On success, it updates the query data changing the [params.propName] property with the new value and 'updatedAt' field if [params.timestamped] is true.
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
        destructive: false,
      );

      if (params.timestamped) {
        ctx.client.setQueryData<List, dynamic>(params.queryKey, (objList) {
          final int id = event.row.$id;

          for (var i = 0; i < objList!.length; i++) {
            final obj = objList[i];

            if (obj.id == id) {
              objList[i] = Function.apply(obj.copyWith, null, {
                Symbol(event.column.field):
                    getValue?.call(event, ctx) ?? event.value,
              });

              return objList;
            }
          }

          return objList;
        });
      }

      params.onSuccess?.call(event, ctx);
    },
  );
}
