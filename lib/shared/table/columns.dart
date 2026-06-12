import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:trina_grid/trina_grid.dart';

abstract class ColumnsEnum implements Enum {
  ColumnsEnum(this.title);

  final String title;
}

class TableColumn extends TrinaColumn {
  final ColumnsEnum column;
  bool? editable;

  TableColumn(
    this.column, {
    required super.type,
    super.renderer,
    super.titleRenderer,
    super.width,
    super.suppressedAutoSize,
    super.enableContextMenu,
    super.textAlign,
    super.titleTextAlign,
    super.enableColumnDrag,
    super.enableDropToResize,
    super.enableRowDrag,
    super.enableFilterMenuItem,
    super.enableAutoEditing,
    this.editable = true,
    super.validator,
  }) : super(
         title: column.title,
         field: column.name,
         enableEditingMode: editable,
         enableSorting: false,
       );

  TableColumn.text(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool autoSize = true,
    bool enableContextMenu = true,
    bool editable = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    TrinaColumnTextAlign titleTextAlign = TrinaColumnTextAlign.start,
    bool enableColumnDrag = true,
    bool enableDropToResize = true,
    Validator validator,
  }) : this(
         column,
         type: .text(),
         renderer: renderer,
         titleRenderer: titleRenderer,
         width: width,
         suppressedAutoSize: !autoSize,
         editable: editable,
         textAlign: textAlign,
         enableContextMenu: enableContextMenu,
         titleTextAlign: titleTextAlign,
         enableColumnDrag: enableColumnDrag,
         enableDropToResize: enableDropToResize,
         validator: validator,
       );

  TableColumn.number(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool editable = true,
    bool autoSize = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    Validator? validator,
  }) : this(
         column,
         type: .number(),
         renderer: renderer,
         titleRenderer: titleRenderer,
         editable: editable,
         textAlign: textAlign,
         width: width,
         suppressedAutoSize: !autoSize,
         validator: validator,
       );

  TableColumn.date(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool editable = true,
    bool autoSize = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    Validator? validator,
  }) : this(
         column,
         type: formattedDateColumnType,
         renderer: renderer,
         titleRenderer: titleRenderer,
         editable: editable,
         textAlign: textAlign,
         width: width,
         suppressedAutoSize: !autoSize,
         validator: validator,
       );
}

typedef Renderer = Widget Function(TrinaColumnRendererContext)?;
typedef TitleRenderer = Widget Function(TrinaColumnTitleRendererContext)?;
typedef Validator = String? Function(dynamic, TrinaValidationContext)?;
