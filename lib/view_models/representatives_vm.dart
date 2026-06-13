import 'package:disco/disco.dart';
import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/repositories/representatives_repo.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_delete.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_update.dart';
import 'package:sistema_escolar_bnl/shared/table/table_vm.dart';

class RepresentativesVm extends TableVm {
  @override
  final RepresentativesRepo repository;

  RepresentativesVm(
    this.repository, {
    super.queryKey = kRepresentativesKey,
    super.mutSuccessName = 'representante',
    super.mutUnauthPluralName = 'representantes',
    super.mutSuccessMsgVocal = 'o',
  });

  static final instance = Provider((context) {
    final db = AppDatabase.instance.of(context);
    final repository = RepresentativesRepo(db);

    return RepresentativesVm(repository);
  });

  final companion = RepresentativesCompanion.new;

  SingleDeleteMutation createDeleteMutation(BuildContext context) =>
      createSingleDeleteMutation(
        .fromCommonParams(mutParams(context), repository.deleteRepresentative),
      );

  SingleUpdateMutation createUpdateMutation(BuildContext context) {
    return createSingleUpdateMutation(
      mutParams(context),
      cb: (column, id, dynamic newValue) =>
          column == RepresentativesTableColumns.cedula.name
          ? repository.patch<int>(column, id, newValue)
          : repository.patch<String>(column, id, newValue),
    );
  }
}
