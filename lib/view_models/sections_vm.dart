import 'package:disco/disco.dart';
import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/constants/sections_constants.dart';
import 'package:sistema_escolar_bnl/repositories/sections_repo.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';
import 'package:sistema_escolar_bnl/shared/table/table_vm.dart';

class SectionsVm extends TableVm {
  @override
  final SectionsRepo repository;

  SectionsVm({
    required this.repository,
    super.mutSuccessName = 'sección',
    super.mutUnauthPluralName = 'secciones',
    super.mutSuccessMsgVocal = 'a',
    super.queryKey = kSectionsKey,
  });

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final sectionsRepository = SectionsRepo(db);

    return SectionsVm(repository: sectionsRepository);
  });

  SingleDeleteMutation createDeleteMutation(BuildContext context) {
    return createSingleDeleteMutation(
      .fromCommonParams(mutParams(context), repository.deleteSection),
    );
  }

  SingleUpdateMutation createUpdateMutation(BuildContext context) {
    return createSingleUpdateMutation(
      mutParams(
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
      cb: (column, id, dynamic newValue) =>
          column == SectionsTableColumns.letter.name
          ? repository.patch<String>(column, id, newValue)
          : repository.patch<int>(column, id, newValue),
    );
  }
}
