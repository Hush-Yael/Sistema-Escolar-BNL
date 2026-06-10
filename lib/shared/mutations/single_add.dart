import 'package:flutter_query/flutter_query.dart';
import 'package:intl/intl.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';

typedef SingleAddMutation<Input> = MutationResult<void, dynamic, Input, void>;

typedef SingleAddMutationCb<Input> = Future<void> Function(Input input);

typedef SingleAddMutationSideEffect<Input> =
    void Function(Input input, MutationFunctionContext ctx);

/// Handles the addition of a single model object.
/// It checks add permission before adding.
/// On success, the object list is refetch.
SingleAddMutation<Input> createSingleAddMutation<Input>(
  SingleCbMutationParams<
    SingleAddMutationCb<Input>,
    SingleAddMutationSideEffect
  >
  params,
) => useMutation(
  (Input input, ctx) async {
    if (!AuthState.isAtLeast(.operator)) {
      return Future.error(
        'No tienes permiso para añadir ${params.unauthPluralName}',
      );
    }

    // return await Future.delayed(const Duration(microseconds: 500), () {
    // return Future.error('error');
    // });

    await params.cb(input);
  },

  onMutate: params.onMutate,

  onSuccess: (_, input, _, ctx) {
    toast(
      context: params.context,
      message:
          '${toBeginningOfSentenceCase(params.successName)} añadid${params.successMsgVocal}',
    );

    ctx.client.invalidateQueries(queryKey: params.queryKey);

    params.onSuccess?.call(input, ctx);
  },

  onError: (error, input, _, ctx) {
    toast(
      context: params.context,
      message: error.toString(),
      destructive: true,
    );

    params.onError?.call(input, ctx);
  },
);
