import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
import 'package:trina_grid/trina_grid.dart';

abstract class IQueryTable<Item extends dynamic, TError extends Exception>
    extends HookWidget {
  final QueryKey queryKey;
  final Future<List<Item>> Function() queryFn;

  final String pluralModelName;
  final String pluralModelArticle;
  final Widget Function()? renderAddBtn;

  final List<TableColumn> Function(BuildContext context) getColumns;
  final TrinaRow Function(Item item)? getRow;
  final Map<String, TrinaCell> Function(Item item)? getCells;
  final void Function(TrinaGridStateManager stateManager) setStateManager;
  final SingleDeleteMutation? deleteMutation;
  final Widget Function(TrinaColumnRendererContext)? actionsRenderer;
  final double actionsWidth;
  final bool showIndexColumn;

  final TrinaGridConfiguration Function(TrinaGridConfiguration baseConfig)?
  createConfig;
  final Widget Function(TrinaGridStateManager)? createFooter;
  final void Function(TrinaGridOnLoadedEvent)? onLoaded;
  final void Function(TrinaGridOnChangedEvent)? onChanged;
  final void Function(TrinaGridOnSelectedEvent)? onSelected;
  final void Function(TrinaGridOnSortedEvent)? onSorted;
  final void Function(TrinaGridOnRowCheckedEvent)? onRowChecked;
  final void Function(TrinaGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(TrinaGridOnRowSecondaryTapEvent)? onRowSecondaryTap;
  final void Function(TrinaGridOnRowEnterEvent)? onRowEnter;
  final void Function(TrinaGridOnRowExitEvent)? onRowExit;
  final void Function(TrinaGridOnRowsMovedEvent)? onRowsMoved;
  final void Function(TrinaGridOnActiveCellChangedEvent)? onActiveCellChanged;
  final void Function(TrinaGridOnColumnsMovedEvent)? onColumnsMoved;
  final bool Function(TrinaGridOnBeforeActiveCellChangeEvent event)?
  onBeforeActiveCellChange;

  const IQueryTable({
    super.key,
    required this.queryKey,
    required this.queryFn,
    required this.pluralModelName,
    required this.pluralModelArticle,
    required this.getColumns,
    required this.setStateManager,
    this.onLoaded,
    this.onChanged,
    this.onSelected,
    this.onSorted,
    this.onRowChecked,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.onRowEnter,
    this.onRowExit,
    this.onRowsMoved,
    this.onActiveCellChanged,
    this.onColumnsMoved,
    this.onBeforeActiveCellChange,
    this.createConfig,
    this.createFooter,
    this.renderAddBtn,
    this.getRow,
    this.getCells,
    this.deleteMutation,
    this.actionsRenderer,
    required this.actionsWidth,
    required this.showIndexColumn,
  });
}
