import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.dart';
import 'package:trina_grid/trina_grid.dart';

class ColToggleBtns extends StatelessWidget {
  final TableColumn column;
  final List<bool> initialValue;
  final List<Widget> children;
  final Function() onCleared;
  final Function(int index) onValueSelected;

  const ColToggleBtns({
    super.key,
    required this.column,
    required this.initialValue,
    required this.children,
    required this.onValueSelected,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    final selection = ListSignal(initialValue);
    final colors = ShadTheme.of(context).colorScheme;

    return SignalBuilder(
      builder: (context, child) => ToggleButtons(
        isSelected: selection.value,
        constraints: const .new(minWidth: 28, minHeight: 28),
        fillColor: colors.primary,
        selectedColor: colors.primaryForeground,
        selectedBorderColor: colors.primary,
        onPressed: (selectedIndex) {
          final isNull = selection.value[selectedIndex] == true;

          if (isNull) {
            onCleared();
            selection.value = selection.value.map((_) => false).toList();
          } else {
            onValueSelected(selectedIndex);

            selection.value = selection.value
                .mapIndexed((index, _) => index == selectedIndex)
                .toList();
          }
        },
        children: children,
      ),
    );
  }
}

class ColPinState extends StatelessWidget {
  final TableColumn column;
  final void Function(TrinaColumn column, TrinaColumnFrozen frozen) freeze;

  const ColPinState({super.key, required this.column, required this.freeze});

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPrefsService.instance.of(context);

    return ColToggleBtns(
      column: column,
      initialValue: [column.frozen.isStart, column.frozen.isEnd],
      children: const [
        RotatedBox(quarterTurns: 1, child: Icon(Icons.push_pin, size: 16)),
        RotatedBox(quarterTurns: -1, child: Icon(Icons.push_pin, size: 16)),
      ],
      onCleared: () {
        final newValue = TrinaColumnFrozen.none;
        freeze(column, newValue);
        prefs.setColPinState(column.field, newValue);
      },
      onValueSelected: (index) {
        final newValue = index == 0
            ? TrinaColumnFrozen.start
            : TrinaColumnFrozen.end;

        freeze(column, newValue);
        prefs.setColPinState(column.field, newValue);
      },
    );
  }
}

class ColOrderState extends StatelessWidget {
  final TableColumn column;

  const ColOrderState({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPrefsService.instance.of(context);
    final orderMode = prefs.getColSortMode(column.field);
    final queryKey = QueryTable.provider.of(context);
    final client = QueryClientProvider.of(context);

    return ColToggleBtns(
      column: column,
      initialValue: [orderMode == .asc, orderMode == .desc],
      children: const [
        Icon(Icons.arrow_upward, size: 16),
        Icon(Icons.arrow_downward, size: 16),
      ],
      onValueSelected: (index) {
        prefs.setColOrderMode(column.field, index == 0 ? .asc : .desc);
        client.invalidateQueries(queryKey: queryKey);
      },
      onCleared: () {
        prefs.setColOrderMode(column.field, null);
        client.invalidateQueries(queryKey: queryKey);
      },
    );
  }
}
