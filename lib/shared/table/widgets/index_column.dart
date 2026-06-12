import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/no_filter_field.dart';

/// Returns a column that contains the index of the row, [listLength] is used to calculate the minimum width needed to fit longest number of the list length
TableColumn indexColumn(int listLength) {
  final span = TextSpan(text: listLength.toString());
  final painter = TextPainter(text: span, textDirection: .ltr, maxLines: 1);

  painter.layout();

  return .new(
    TableSpecialCols.Index,
    type: .number(),
    titleTextAlign: .right,
    suppressedAutoSize: true,
    width: painter.width + 30,
    editable: false,
    enableFilterMenuItem: false,
    enableColumnDrag: false,
    enableContextMenu: false,
    enableDropToResize: false,
    filterWidgetDelegate: noFilterField(),
    renderer: (rendererContext) {
      return Text(
        (rendererContext.rowIdx + 1).toString(),
        textAlign: .right,
        style: tabularNums,
      );
    },
  );
}
