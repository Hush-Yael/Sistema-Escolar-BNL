import 'package:trina_grid/trina_grid.dart';

mixin VmTrinaGridMixin {
  TrinaGridStateManager? _stateManager;

  TrinaGridStateManager? getStateManager() => _stateManager;

  void setStateManager(TrinaGridStateManager stateManager) {
    _stateManager = stateManager;
  }
}
