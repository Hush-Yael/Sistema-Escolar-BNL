import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/columns_btn/col_toggle_btns.dart';
import 'package:trina_grid/trina_grid.dart';

class ColumnsBtn<ColumnItem> extends HookWidget {
  final TrinaGridStateManager state;
  final List<TableColumn<ColumnItem>> columns;

  const ColumnsBtn({super.key, required this.state, required this.columns});

  @override
  Widget build(BuildContext context) {
    final popoverController = ShadPopoverController();

    useEffect(() {
      return () {
        popoverController.dispose();
      };
    }, []);

    final longestCol = columns.reduce(
      (a, b) => a.title.length > b.title.length ? a : b,
    );

    final span = TextSpan(text: longestCol.title);
    final painter = TextPainter(text: span, textDirection: .ltr, maxLines: 1);
    painter.layout();

    final double titleWidth = painter.width + 100;
    final double othersWidth = 100;

    return ShadPopover(
      controller: popoverController,
      anchor: ShadAnchor(
        overlayAlignment: .bottomEnd,
        childAlignment: .topEnd,
        offset: .new(0, 5),
      ),
      child: ShadButton.secondary(
        size: .sm,
        leading: const Icon(LucideIcons.columns3),
        onPressed: popoverController.toggle,
        child: const Text('Columnas'),
      ),
      popover: (context) {
        return ConstrainedBox(
          constraints: .new(
            maxWidth: min(
              titleWidth + othersWidth * 2,
              MediaQuery.of(context).size.width * 0.4,
            ),
            maxHeight: min(
              55.0 * columns.length,
              MediaQuery.of(context).size.height * 0.8,
            ),
          ),
          child: ShadTable.list(
            header: const [
              ShadTableCell.header(
                child: Text('Columna', style: .new(fontWeight: .bold)),
              ),

              ShadTableCell.header(
                alignment: .center,
                child: Text('Orden', style: .new(fontWeight: .bold)),
              ),

              ShadTableCell.header(
                alignment: .center,
                child: Text('Fijar', style: .new(fontWeight: .bold)),
              ),
            ],
            columnSpanExtent: (index) {
              return FixedSpanExtent(index > 0 ? othersWidth : titleWidth);
            },
            children: columns.map((col) {
              return [
                ShadTableCell(
                  child: Row(
                    mainAxisSize: .min,
                    spacing: 10,
                    children: [
                      ColVisibility(column: col, toggle: state.hideColumn),

                      Text(col.title, textAlign: .left, overflow: .ellipsis),
                    ],
                  ),
                ),

                ShadTableCell(
                  alignment: .center,
                  child: (col.sortable == true)
                      ? ColOrderState(column: col)
                      : const SizedBox.shrink(),
                ),

                ShadTableCell(
                  alignment: .center,
                  child: ColPinState(
                    column: col,
                    freeze: state.toggleFrozenColumn,
                  ),
                ),
              ];
            }),
          ),
        );
      },
    );
  }
}

class ColVisibility extends StatelessWidget {
  final TrinaColumn column;
  final void Function(TrinaColumn column, bool hide) toggle;

  const ColVisibility({super.key, required this.column, required this.toggle});

  @override
  Widget build(BuildContext context) {
    final visible = Signal(!column.hide);
    final prefs = SharedPrefsService.instance.of(context);

    return SignalBuilder(
      builder: (context, child) => ShadIconButton.raw(
        height: 24,
        width: 24,
        iconSize: 16,
        variant: visible.value ? .primary : .outline,
        icon: visible.value
            ? const Icon(Icons.visibility)
            : const Icon(Icons.visibility_off),
        onPressed: () {
          visible.value = !visible.value;
          toggle(column, !visible.value);
          prefs.setColHideState(column.field, !visible.value);
        },
      ),
    );
  }
}
