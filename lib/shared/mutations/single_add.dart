import 'package:flutter_query/flutter_query.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:trina_grid/trina_grid.dart';

typedef SingleAddMutation<Variables, NewObj extends Object> =
    MutationResult<int, Exception, Variables, ({TrinaRow row, NewObj newObj})>;

typedef SingleAddMutationCb<Variables, AddedObj extends dynamic> =
    Future<AddedObj> Function(Variables variables);

typedef SingleAddMutationSideEffect<Variables, NewObj extends Object> =
    void Function(Variables variables, ({TrinaRow row, NewObj newObj}) record);

/// Handles the addition of a single model object.
/// It checks add permission before adding.
/// On mutation it create a new row using a new object and adds it to the rows list.
/// On error, the new row is removed from the rows list.
/// On success, the new object is added to the query list.
SingleAddMutation<Variables, NewObj>
createSingleAddMutation<Variables, NewObj extends Object>(
  MutationCommonParams<
    SingleAddMutationCb<Variables, NewObj>,
    SingleAddMutationSideEffect
  >
  params, {
  required NewObj Function(Variables variables) createNewObj,
  required TrinaRow Function(int rowsLength, NewObj newObj) createRow,
}) => useMutation(
  (Variables variables, ctx) async {
    if (!AuthState.isAtLeast(.operator)) {
      return Future.error(
        'No tienes permiso para añadir ${params.unauthPluralName}',
      );
    }

    /* return await Future.delayed(const Duration(seconds: 2), () {
      return Future.error('error');
      return 11;
    }); */

    final newObj = await params.cb(variables);
    return (newObj as dynamic).id;
  },

  onMutate: (variables, ctx) {
    try {
      final state = params.getStateManager()!;

      final newObj = createNewObj(variables);

      final newRow = createRow(state.refRows.length, newObj);

      state.insertRows(state.refRows.length, [newRow]);

      final record = (row: newRow, newObj: newObj);

      params.onMutate?.call(variables, record);

      return record;
    } catch (e) {
      print(e);
      rethrow;
    }
  },

  onSuccess: (addedId, variables, returned, ctx) {
    toast(
      context: params.context,
      message:
          '${toBeginningOfSentenceCase(params.successName)} añadid${params.successMsgVocal}',
    );

    returned!.row.$id = addedId;

    ctx.client.setQueryData<List, Exception>(params.queryKey, (list) {
      list!.add(
        Function.apply((returned.newObj as dynamic).copyWith, null, {
          #id: addedId,
        }),
      );
      return list;
    });

    params.onSuccess?.call(variables, returned);
  },

  onError: (error, variables, returned, ctx) {
    toast(context: params.context, message: error.toString());

    final state = params.getStateManager()!;

    state.refRows.remove(returned!.row);

    params.onError?.call(variables, returned);

    state.notifyListeners();
  },
);
