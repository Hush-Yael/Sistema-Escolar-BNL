import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
import 'package:trina_grid/trina_grid.dart';
export 'single_add.dart';

class MutationCommonParams<
  Callback extends Function,
  SideEffect extends Function?
> {
  final BuildContext context;
  final QueryKey queryKey;
  final TrinaGridStateManager? Function() getStateManager;

  /// Name to be shown in the success message
  final String successName;

  /// Plural form of the object name, shown in the unauthorized error message
  final String unauthPluralName;

  /// Suffix added to the performed action word next to the object name in the success message
  final String successMsgVocal;

  /// Whether the mutation should update the 'updatedAt' field
  final bool timestamped;

  /// The async function that performs the mutation on the db
  final Callback cb;

  /// Do something before the mutation resolves
  final SideEffect? onMutate;

  /// Do something when the mutation fails
  final SideEffect? onError;

  /// Do something when the mutation succeeds
  final SideEffect? onSuccess;

  const MutationCommonParams(
    this.context, {
    required this.queryKey,
    required this.timestamped,
    required this.cb,
    required this.getStateManager,
    required this.successName,
    required this.unauthPluralName,
    this.successMsgVocal = 'o',
    this.onMutate,
    this.onError,
    this.onSuccess,
  });
}
