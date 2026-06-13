import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:trina_grid/trina_grid.dart';

abstract class ColumnsEnum implements Enum {
  ColumnsEnum(this.title);

  final String title;
}

class TableColumn<Item> extends TrinaColumn {
  final ColumnsEnum column;
  bool? editable;
  bool? sortable;
  Validator? validate;
  final dynamic Function(Item item) getCellValue;

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
    required this.getCellValue,
  }) : super(
         title: column.title,
         field: column.name,
         enableEditingMode: editable,
         enableSorting: false,
         frozen: SharedPrefsService.getColPinState(column.name),
         hide: SharedPrefsService.getColHideState(column.name),
         validator: validate != null
             ? (value, context) =>
                   validate(value is! String ? value.toString() : value)
             : null,
       );

  TrinaCell getCell(Item item) => TrinaCell(value: getCellValue(item));

  TableColumn.text(
    ColumnsEnum column, {
    Renderer renderer,
    TitleRenderer titleRenderer,
    double width = TrinaGridSettings.columnWidth,
    double minWidth = TrinaGridSettings.minColumnWidth,
    bool autoSize = true,
    bool enableContextMenu = true,
    bool editable = true,
    bool sortable = true,
    TrinaColumnTextAlign textAlign = TrinaColumnTextAlign.start,
    TrinaColumnTextAlign titleTextAlign = TrinaColumnTextAlign.start,
    bool enableColumnDrag = true,
    bool enableDropToResize = true,
    Validator validate,
    required String Function(Item item) getCellValue,
  }) : this(
         column,
         type: .text(),
         renderer: renderer,
         titleRenderer: titleRenderer,
         width: width,
         minWidth: minWidth,
         suppressedAutoSize: !autoSize,
         editable: editable,
         sortable: sortable,
         textAlign: textAlign,
         enableContextMenu: enableContextMenu,
         titleTextAlign: titleTextAlign,
         enableColumnDrag: enableColumnDrag,
         enableDropToResize: enableDropToResize,
         validate: validate,
         getCellValue: getCellValue,
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
    required num Function(Item item) getCellValue,
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
         getCellValue: getCellValue,
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
    required DateTime? Function(Item item) getCellValue,
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
