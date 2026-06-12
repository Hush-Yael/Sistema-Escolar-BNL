import 'package:flutter/material.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
import 'package:trina_grid/trina_grid.dart';

class MenuDelegate implements TrinaColumnMenuDelegate {
  final BuildContext context;
  final QueryKey queryKey;

  const MenuDelegate(this.context, this.queryKey);

  final TrinaColumnMenuDelegateDefault _defaultDelegate =
      const TrinaColumnMenuDelegateDefault();

  @override
  List<PopupMenuEntry<dynamic>> buildMenuItems({
    required TrinaGridStateManager stateManager,
    required TrinaColumn column,
  }) {
    column as TableColumn;

    final items = _defaultDelegate.buildMenuItems(
      stateManager: stateManager,
      column: column,
    );

    items.removeWhere((element) {
      if (element is PopupMenuItem<String>) {
        switch (element.value) {
          case TrinaColumnMenuDelegateDefault.defaultMenuResetFilter:
          case TrinaColumnMenuDelegateDefault.defaultMenuSetColumns:
          case TrinaColumnMenuDelegateDefault.defaultMenuSetFilter:
            return true;
          default:
            return false;
        }
      }

      return false;
    });

    if (column.sortable != true) return items;

    final field = column.field;
    final prefs = SharedPrefsService.instance.of(context);
    final order = prefs.getColSortMode(field);
    final client = QueryClientProvider.of(context);

    return [
      ...items,

      CheckedPopupMenuItem(
        checked: order == null,
        child: const Text('No ordenar'),
        onTap: () {
          prefs.setColOrderMode(field, null);
          client.invalidateQueries(queryKey: queryKey);
        },
      ),

      CheckedPopupMenuItem(
        checked: order == .asc,
        child: const Text('Ordenar ascendente'),
        onTap: () {
          prefs.setColOrderMode(field, .asc);
          client.invalidateQueries(queryKey: queryKey);
        },
      ),

      CheckedPopupMenuItem(
        checked: order == .desc,
        child: const Text('Ordenar descendente'),
        onTap: () {
          prefs.setColOrderMode(field, .desc);
          client.invalidateQueries(queryKey: queryKey);
        },
      ),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required TrinaGridStateManager stateManager,
    required TrinaColumn column,
    required bool mounted,
    required selected,
  }) {
    _defaultDelegate.onSelected(
      context: context,
      stateManager: stateManager,
      column: column,
      mounted: mounted,
      selected: selected,
    );
  }
}
