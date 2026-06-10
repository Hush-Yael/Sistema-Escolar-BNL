import 'package:flutter_query/flutter_query.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:sistema_escolar_bnl/core/utils/table_utils.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:intl/intl.dart';

typedef SingleDeleteMutation =
    MutationResult<dynamic, dynamic, TrinaColumnRendererContext, int>;

typedef SingleDeleteMutationSideEffect =
    void Function(TrinaColumnRendererContext columnCtx)?;

typedef SingleDeleteMutationCb = Future<int> Function(int id);

/// Handles a delete mutation for a single model object.
/// It checks delete permission before deleting.
/// On mutation it deletes the object from the rows list.
/// On error, it readds the deleted object to the rows list.
/// On success, it deletes the object from the query list.
SingleDeleteMutation createSingleDeleteMutation<TListData extends List>(
  SingleCbMutationParams<SingleDeleteMutationCb, SingleDeleteMutationSideEffect>
  params,
) {
  assert(params.getStateManager != null);

  return useMutation(
    (ctx, _) async {
      if (!AuthState.isAdmin()) {
        return Future.error(
          'No tienes permiso para eliminar $params.unauthPluralName',
        );
      }

      final id = ctx.row.$id;

      /*  return await Future.delayed(const Duration(seconds: 1), () {
        return Random().nextBool() ? Future.error('error') : id;
      }); */

      return await params.cb(id);
    },

    onMutate: (colCtx, _) {
      final rows = params.getStateManager!()!.refRows;
      final id = colCtx.row.$id;

      params.onMutate?.call(colCtx);

      for (var i = 0; i < rows.length; i++) {
        final row = rows[i];

        if (row.$id == id) {
          rows.removeAt(i);
          return i - 1;
        }
      }

      return rows.length - 2;
    },

    onError: (error, columnCtx, beforeIndex, _) {
      toast(
        context: params.context,
        message: error.toString(),
        destructive: true,
      );

      try {
        params.getStateManager!()!.refRows.insert(
          beforeIndex! + 1,
          columnCtx.row,
        );
        params.onError?.call(columnCtx);
      } catch (e) {
        print(e);
        rethrow;
      }
    },

    onSuccess: (_, columnCtx, _, ctx) {
      toast(
        context: params.context,
        message:
            '${toBeginningOfSentenceCase(params.successName)} eliminad${params.successMsgVocal}',
      );

      ctx.client.setQueryData<TListData, dynamic>(params.queryKey, (objList) {
        final id = columnCtx.row.$id;

        objList!.removeWhere((obj) => obj.id == id);

        return objList;
      });

      params.onSuccess?.call(columnCtx);
    },
  );
}
