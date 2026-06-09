import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/constants/sections_constants.dart';
import 'package:sistema_escolar_bnl/repositories/sections_repo.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';
import 'package:sistema_escolar_bnl/shared/table/table_vm.dart';

class SectionsVm extends TableVm {
  @override
  final SectionsRepo repository;

  SectionsVm({required this.repository});

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final sectionsRepository = SectionsRepo(db);

    return SectionsVm(repository: sectionsRepository);
  });

  MutationCommonParams<S> _params<S extends Function>(
    BuildContext context, {
    S? onSuccess,
    S? onError,
  }) => MutationCommonParams<S>(
    context,
    timestamped: false,
    queryKey: kSectionsKey,
    getStateManager: getStateManager,
    successName: 'sección',
    unauthPluralName: 'secciones',
    successMsgVocal: 'a',
    onSuccess: onSuccess,
    onError: onError,
  );

  SingleDeleteMutation createDeleteMutation(BuildContext context) {
    return createSingleDeleteMutation(
      .fromCommonParams(_params(context), repository.deleteSection),
    );
  }

  SingleUpdateMutation createUpdateMutation(BuildContext context) {
    return createSingleUpdateMutation(
      _params(
        context,
        onSuccess: (event, ctx) {
          final column = event.column.field;

          // update enrollment
          if (column == SectionsTableColumns.capacity.name) {
            final capacity =
                event.row.cells[SectionsTableColumns.capacity.name]!.value;
            final studentCount =
                event.row.cells[SectionsTableColumns.studentsCount.name]!.value;

            event.row.cells[SectionsTableColumns.enrollment.name]!.value =
                capacity - studentCount;
          }
        },
      ),
      cb: (column, id, newValue) {
        if (column == SectionsTableColumns.letter.name) {
          final String letter = (newValue as String).trim();

          if (letter.isEmpty) {
            throw ErrorDescription('La letra no puede estar vacía');
          }

          if (letter.length > 1) {
            throw ErrorDescription('Solo se acepta un carácter');
          }

          if (!RegExp(r'^[A-Za-zñÑ]$').hasMatch(newValue)) {
            throw ErrorDescription('Solo se aceptan letras');
          }

          return repository.updateLetter(id, newValue);
        }

        if (column == SectionsTableColumns.capacity.name) {
          final int capacity = (newValue as int);

          if (capacity <= 0) {
            throw ErrorDescription('La capacidad debe ser mayor a 0');
          }

          return repository.updateCapacity(id, capacity);
        }

        throw ErrorDescription('La columna $column no es editable');
      },
      getValue: (event, ctx) => event.value,
    );
  }
}
