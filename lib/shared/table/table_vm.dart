import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:trina_grid/trina_grid.dart';
import 'package:meta/meta.dart';

class TableVm {
  @mustBeOverridden
  Repository get repository =>
      throw UnimplementedError('repository must be implemented');

  TrinaGridStateManager? _stateManager;

  TrinaGridStateManager? getStateManager() => _stateManager;

  void setStateManager(TrinaGridStateManager stateManager) {
    _stateManager = stateManager;
  }
}
