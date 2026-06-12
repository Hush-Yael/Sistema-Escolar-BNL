import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:trina_grid/trina_grid.dart';

abstract class ColumnsEnum implements Enum {
  ColumnsEnum(this.title);

  final String title;
}

class TableColumn extends TrinaColumn {
  final ColumnsEnum column;
  bool? editable;
  bool? sortable;
  Validator? validate;

  TableColumn(
    this.column, {
    required super.type,
    super.renderer,
    super.titleRenderer,
    super.width,
    super.minWidth,
    super.suppressedAutoSize,
    super.enableContextMenu,
    super.textAlign,
    super.titleTextAlign,
    super.enableColumnDrag,
    super.enableDropToResize,
    super.enableRowDrag,
    super.enableFilterMenuItem,
    super.enableAutoEditing,
    super.filterWidgetDelegate,
    this.editable = true,
    this.sortable = true,
    this.validate,
  }) : super(
         title: column.title,
         field: column.name,
         enableEditingMode: editable,
         enableSorting: false,
         frozen: SharedPrefsService.getColPinState(column.name),
         hide: SharedPrefsService.getColHideState(column.name),
         validator: validate != null
             ? (value, context) => validate(value)
             : null,
       );

  TableColumn.text(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool autoSize = true,
    bool enableContextMenu = true,
    bool editable = true,
    bool sortable = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    TrinaColumnTextAlign titleTextAlign = TrinaColumnTextAlign.start,
    bool enableColumnDrag = true,
    bool enableDropToResize = true,
    Validator validate,
  }) : this(
         column,
         type: .text(),
         renderer: renderer,
         titleRenderer: titleRenderer,
         width: width,
         suppressedAutoSize: !autoSize,
         editable: editable,
         sortable: sortable,
         textAlign: textAlign,
         enableContextMenu: enableContextMenu,
         titleTextAlign: titleTextAlign,
         enableColumnDrag: enableColumnDrag,
         enableDropToResize: enableDropToResize,
         validate: validate,
       );

  TableColumn.number(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool editable = true,
    bool sortable = true,
    bool autoSize = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    Validator? validate,
  }) : this(
         column,
         type: .number(),
         renderer: renderer,
         titleRenderer: titleRenderer,
         editable: editable,
         sortable: sortable,
         textAlign: textAlign,
         width: width,
         suppressedAutoSize: !autoSize,
         validate: validate,
       );

  TableColumn.date(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    bool editable = true,
    bool sortable = true,
    bool autoSize = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    Validator? validate,
  }) : this(
         column,
         type: formattedDateColumnType,
         renderer: renderer,
         titleRenderer: titleRenderer,
         editable: editable,
         sortable: sortable,
         textAlign: textAlign,
         width: width,
         suppressedAutoSize: !autoSize,
         validate: validate,
       );
}

typedef Renderer = Widget Function(TrinaColumnRendererContext)?;
typedef TitleRenderer = Widget Function(TrinaColumnTitleRendererContext)?;
typedef Validator = String? Function(String?)?;
