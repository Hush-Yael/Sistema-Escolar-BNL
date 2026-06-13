import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/no_filter_field.dart';
import 'package:trina_grid/trina_grid.dart';

TableColumn<T> actionsColumn<T>({
  double width = 90,
  required Widget Function(TrinaColumnRendererContext)? renderer,
}) {
  return .new(
    TableSpecialCols.actions,
    titleTextAlign: .center,
    type: .custom(),
    width: width,
    minWidth: width,
    suppressedAutoSize: true,
    editable: false,
    sortable: false,
    enableColumnDrag: false,
    enableContextMenu: false,
    enableDropToResize: false,
    enableFilterMenuItem: false,
    filterWidgetDelegate: noFilterField(),
    renderer: renderer,
    getCellValue: (item) => throw UnimplementedError(),
  );
}
