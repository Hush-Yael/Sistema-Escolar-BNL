import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/table_config.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/actions_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/index_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.d.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_empty_state.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_fetch_error.dart';
import 'package:trina_grid/trina_grid.dart';

class QueryTable<Item extends dynamic, TError extends Exception>
    extends IQueryTable<Item, TError>
    with TableConfig {
  const QueryTable({
    super.key,
    required super.queryKey,
    required super.queryFn,
    required super.pluralModelName,
    required super.pluralModelArticle,
    required super.getColumns,
    required super.setStateManager,
    super.renderAddBtn,
    super.getCells,
    super.getRow,
    super.deleteMutation,
    super.createConfig,
    super.createFooter,
    super.onLoaded,
    super.onChanged,
    super.onSelected,
    super.onSorted,
    super.onRowChecked,
    super.onRowDoubleTap,
    super.onRowSecondaryTap,
    super.onRowEnter,
    super.onRowExit,
    super.onRowsMoved,
    super.onActiveCellChanged,
    super.onColumnsMoved,
    super.onBeforeActiveCellChange,
    super.actionsRenderer,
    super.actionsWidth = 90,
    super.showIndexColumn = true,
  }) : assert(
         getCells != null || getRow != null,
         'Either getCells or getRow must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final state = useState<TrinaGridStateManager?>(null);
    final isEmpty = useState<bool>(false);
    final query = useQuery(queryKey, (ctx) => delay(queryFn()));

    final baseConfig = getBaseConfig(context);
    final config = createConfig != null
        ? createConfig!(baseConfig)
        : baseConfig;

    final columns = getColumns(context);

    if (showIndexColumn) {
      columns.insert(0, indexColumn((query.data?.length ?? 0)));
    }

    if (actionsRenderer != null && AuthState.isAdmin()) {
      // Add actions column to the end of the columns list
      columns.add(
        actionsColumn(width: actionsWidth, renderer: actionsRenderer),
      );
    }

    useEffect(() {
      if (!query.isFetching && query.isSuccess && state.value != null) {
        if (query.data == null || query.data!.isEmpty) {
          isEmpty.value = true;
          state.value!.setShowLoading(false);
          return;
        }

        TrinaGridStateManager.initializeRowsAsync(
          columns,

          query.data!.map((item) {
            if (getRow != null) return getRow!(item);

            final cells = showIndexColumn || actionsRenderer != null
                ? {
                    if (showIndexColumn) kIndexColumnField: TrinaCell(),

                    if (actionsRenderer != null)
                      kActionsColumnName: TrinaCell(),

                    ...getCells!(item),
                  }
                : getCells!(item);

            return TrinaRow(metadata: {'id': item.id}, cells: cells);
          }).toList(),
        ).then((newRows) {
          state.value!.refRows.clear();
          state.value!.refRows.addAll(newRows);

          state.value!.setShowLoading(false);
        });
      }

      if (query.isRefetching && query.isFetched && state.value != null) {
        state.value!.setShowLoading(true, level: .rows);
      }

      return null;
    }, [query, state]);

    if (query.isError) {
      return TableFetchError(
        query.error,
        'Error al cargar $pluralModelArticle $pluralModelName',
      );
    }

    if (isEmpty.value) {
      return TableEmptyState(
        pluralModelName: pluralModelName,
        renderAddBtn: renderAddBtn,
      );
    }

    return TrinaGrid(
      rows: [],
      columns: columns,
      configuration: config,
      onLoaded: (e) {
        final stateManager = e.stateManager;
        state.value = stateManager;

        setStateManager(stateManager);

        stateManager.setShowLoading(true);

        onLoaded?.call(e);
      },
      createHeader: renderAddBtn == null
          ? null
          : (stateManager) {
              return SizedBox(
                height: 60,
                child: Padding(
                  padding: const .all(8.0),
                  child: Align(alignment: .centerEnd, child: renderAddBtn!()),
                ),
              );
            },
      createFooter: createFooter,
      onBeforeActiveCellChange: _onBeforeActiveCellChange,
      onChanged: onChanged,
      onSelected: onSelected,
      onSorted: onSorted,
      onRowChecked: onRowChecked,
      onRowDoubleTap: onRowDoubleTap,
      onRowSecondaryTap: onRowSecondaryTap,
      onRowEnter: onRowEnter,
      onRowExit: onRowExit,
      onRowsMoved: onRowsMoved,
      onActiveCellChanged: onActiveCellChanged,
      onColumnsMoved: onColumnsMoved,
    );
  }

  bool _onBeforeActiveCellChange(TrinaGridOnBeforeActiveCellChangeEvent e) {
    final cellIsEditable = e.newCell.column.enableEditingMode == true;

    if (onBeforeActiveCellChange != null) {
      return cellIsEditable && onBeforeActiveCellChange!(e);
    }

    return cellIsEditable;
  }
}
