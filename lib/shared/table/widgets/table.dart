import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/shared_prefs_service.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/menu_delegate.dart';
import 'package:sistema_escolar_bnl/shared/table/table_config.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/actions_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/columns_btn/columns_btn.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/index_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table.d.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_empty_state.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_fetch_error.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
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
    super.getRow,
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
  });

  static final provider = Provider.withArgument(
    (_, QueryKey queryKey) => queryKey,
  );

  @override
  Widget build(BuildContext context) {
    final prefs = SharedPrefsService.instance.of(context);
    final columns = getColumns(context);

    final state = useState<TrinaGridStateManager?>(null);
    final isEmpty = useState<bool>(false);

    final query = useQuery(queryKey, (ctx) {
      final OrderTerms sortTerms = columns
          .map(
            (col) => (field: col.field, mode: prefs.getColSortMode(col.field)),
          )
          .where((col) => col.mode != null)
          .toList();

      return delay(queryFn(sortTerms));
    });

    final baseConfig = getBaseConfig(context);
    final config = createConfig != null
        ? createConfig!(baseConfig)
        : baseConfig;

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

            final Map<String, TrinaCell> cellsMap = {
              for (final col in columns)
                if (col.field != TableSpecialCols.Index.name &&
                    col.field != TableSpecialCols.actions.name)
                  col.field: col.getCell(item),
            };

            final cells = showIndexColumn || actionsRenderer != null
                ? {
                    if (showIndexColumn)
                      TableSpecialCols.Index.name: TrinaCell(),

                    if (actionsRenderer != null)
                      TableSpecialCols.actions.name: TrinaCell(),

                    ...cellsMap,
                  }
                : cellsMap;

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

    if (!query.isRefetching && query.isError) {
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
      columnMenuDelegate: MenuDelegate(context, queryKey),
      onLoaded: (e) {
        final stateManager = e.stateManager;
        state.value = stateManager;

        setStateManager(stateManager);

        stateManager.setShowLoading(true);

        onLoaded?.call(e);
      },
      createHeader: (stateManager) {
        return ProviderScope(
          providers: [provider(queryKey)],
          child: SizedBox(
            height: 60,
            child: Padding(
              padding: const .all(8.0),
              child: Row(
                children: [
                  const Spacer(),

                  Row(
                    spacing: 10,
                    children: [
                      ColumnsBtn<Item>(state: stateManager, columns: columns),

                      if (renderAddBtn != null) renderAddBtn!(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      createFooter: createFooter,
      onValidationFailed: (e) {
        toast(
          context: context,
          message: e.errorMessage,
          destructive: true,
          alignment: .bottomLeft,
        );
      },
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
