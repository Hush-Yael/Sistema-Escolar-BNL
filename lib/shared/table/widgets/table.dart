import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_query/flutter_query.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/table/constants.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/actions_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/index_column.dart';
import 'package:sistema_escolar_bnl/shared/table/widgets/table_fetch_error.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';
import 'package:trina_grid/trina_grid.dart';

class QueryTable<Item extends dynamic, TError extends Exception>
    extends HookWidget {
  final QueryKey queryKey;
  final Future<List<Item>> Function() queryFn;

  final String pluralModelName;
  final String pluralModelArticle;
  final void Function()? onAdd;

  final List<TrinaColumn> Function(BuildContext context) getColumns;
  final TrinaRow Function(Item item)? getRow;
  final Map<String, TrinaCell> Function(Item item)? getCells;
  final void Function(TrinaGridStateManager stateManager) setStateManager;
  final SingleDeleteMutation? deleteMutation;
  final Widget Function(TrinaColumnRendererContext)? actionsRenderer;
  final double actionsWidth;
  final bool showIndexColumn;

  final TrinaGridConfiguration Function(TrinaGridConfiguration baseConfig)?
  createConfig;
  final Widget Function(TrinaGridStateManager)? createHeader;
  final Widget Function(TrinaGridStateManager)? createFooter;

  final void Function(TrinaGridOnLoadedEvent)? onLoaded;
  final void Function(TrinaGridOnChangedEvent)? onChanged;
  final void Function(TrinaGridOnSelectedEvent)? onSelected;
  final void Function(TrinaGridOnSortedEvent)? onSorted;
  final void Function(TrinaGridOnRowCheckedEvent)? onRowChecked;
  final void Function(TrinaGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final void Function(TrinaGridOnRowSecondaryTapEvent)? onRowSecondaryTap;
  final void Function(TrinaGridOnRowEnterEvent)? onRowEnter;
  final void Function(TrinaGridOnRowExitEvent)? onRowExit;
  final void Function(TrinaGridOnRowsMovedEvent)? onRowsMoved;
  final void Function(TrinaGridOnActiveCellChangedEvent)? onActiveCellChanged;
  final void Function(TrinaGridOnColumnsMovedEvent)? onColumnsMoved;
  final bool Function(TrinaGridOnBeforeActiveCellChangeEvent event)?
  onBeforeActiveCellChange;

  const QueryTable({
    super.key,
    required this.queryKey,
    required this.queryFn,
    required this.pluralModelName,
    required this.pluralModelArticle,
    required this.getColumns,
    required this.setStateManager,
    this.onAdd,
    this.getCells,
    this.getRow,
    this.deleteMutation,
    this.createConfig,
    this.createHeader,
    this.createFooter,
    this.onLoaded,
    this.onChanged,
    this.onSelected,
    this.onSorted,
    this.onRowChecked,
    this.onRowDoubleTap,
    this.onRowSecondaryTap,
    this.onRowEnter,
    this.onRowExit,
    this.onRowsMoved,
    this.onActiveCellChanged,
    this.onColumnsMoved,
    this.onBeforeActiveCellChange,
    this.actionsRenderer,
    this.actionsWidth = 90,
    this.showIndexColumn = true,
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
          state.value!.refRows.clearFromOriginal();
          state.value!.refRows.addAll(newRows);

          state.value!.setShowLoading(false);
        });
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
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: ShadTheme.of(context).colorScheme.border),
          borderRadius: const .all(.circular(8)),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              const Icon(LucideIcons.sheet, size: 40),

              const SizedBox(height: 10),

              const Text(
                'No hay nada para mostrar',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 4),

              Text(
                'Parece que no se han añadido $pluralModelName',
                style: TextStyle(
                  color: ShadTheme.of(context).colorScheme.mutedForeground,
                ),
              ),

              const SizedBox(height: 20),

              if (onAdd != null)
                ShadButton(
                  width: 300,
                  onPressed: onAdd,
                  enabled: AuthState.isAtLeast(.operator),
                  trailing: const Icon(LucideIcons.arrowRight, size: 20),
                  child: Text(
                    'Agregar un${pluralModelArticle.endsWith('os') ? 'o' : 'a'}',
                  ),
                ),
            ],
          ),
        ),
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
      createHeader: createHeader,
      createFooter: createFooter,
      onBeforeActiveCellChange: (e) {
        final cellIsEditable = e.newCell.column.enableEditingMode == true;

        if (onBeforeActiveCellChange != null) {
          return cellIsEditable && onBeforeActiveCellChange!(e);
        }

        return cellIsEditable;
      },
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

  TrinaGridConfiguration getBaseConfig(BuildContext context) =>
      TrinaGridConfiguration(
        selectingMode: .none,

        localeText: TrinaGridLocaleText.spanish(
          unfreezeColumn: 'Desfijar columna',
          freezeColumnToEnd: 'Fijar columna al final',
          freezeColumnToStart: 'Fijar columna al inicio',
          autoFitColumn: 'Ajustar columna al contenido',
          hideColumn: 'Esconder columna',
          setColumns: 'Establecer columnas',
          setColumnsTitle: 'Todas',
          setFilter: 'Filtrar',
          resetFilter: 'Limpiar filtro',

          filterType: 'Filtro',

          filterContains: 'Contiene',
          filterEquals: 'Es igual a',
          filterGreaterThan: 'Mayor que',
          filterGreaterThanOrEqualTo: 'Mayor o igual que',
          filterLessThan: 'Menor que',
          filterLessThanOrEqualTo: 'Menor o igual que',
        ),

        scrollbar: .new(columnShowScrollWidth: false),

        columnSize: .new(autoSizeMode: .equal),

        columnFilter: .new(debounceMilliseconds: 500),

        style: Function.apply(
          context.theme.brightness == Brightness.dark
              ? TrinaGridStyleConfig.dark
              : TrinaGridStyleConfig.new,
          null,
          {
            #gridBackgroundColor: context.theme.colorScheme.card,

            #borderColor: context.theme.colorScheme.border,

            #gridBorderColor: context.theme.colorScheme.border,

            #gridBorderRadius: BorderRadius.all(.circular(4)),

            #columnTextStyle: TextStyle(
              color: context.theme.colorScheme.cardForeground,
              fontWeight: .bold,
            ),

            #filterIcon: null,

            #menuBackgroundColor: context.theme.colorScheme.popover,

            #rowColor: context.theme.colorScheme.card,

            #rowCheckedColor: context.theme.colorScheme.card,

            #cellColorInEditState: context.theme.colorScheme.muted,

            #cellCheckedColor: context.theme.colorScheme.primary,

            // whole row color when a cell has selection
            #activatedColor: Colors.transparent,

            #activatedBorderColor: context.theme.colorScheme.primary,
          },
        ),
      );
}
