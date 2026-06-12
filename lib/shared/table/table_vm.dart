import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:meta/meta.dart';

class TableVm {
  final QueryKey queryKey;
  final String mutSuccessName;
  final String mutUnauthPluralName;
  final String mutSuccessMsgVocal;

  TableVm({
    required this.queryKey,
    required this.mutSuccessName,
    required this.mutUnauthPluralName,
    required this.mutSuccessMsgVocal,
  });

  @mustBeOverridden
  Repository get repository =>
      throw UnimplementedError('repository must be implemented');

  TrinaGridStateManager? _stateManager;

  TrinaGridStateManager? getStateManager() => _stateManager;

  void setStateManager(TrinaGridStateManager stateManager) {
    _stateManager = stateManager;
  }

  @protected
  MutationCommonParams<S> mutParams<S extends Function>(
    BuildContext context, {
    S? onSuccess,
    S? onError,
  }) => MutationCommonParams<S>(
    context,
    queryKey: queryKey,
    getStateManager: getStateManager,
    successName: mutSuccessName,
    unauthPluralName: mutUnauthPluralName,
    successMsgVocal: mutSuccessMsgVocal,
    onSuccess: onSuccess,
    onError: onError,
  );
}
