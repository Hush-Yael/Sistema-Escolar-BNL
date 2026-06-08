import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';
import 'package:trina_grid/trina_grid.dart';

mixin TableConfig {
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
