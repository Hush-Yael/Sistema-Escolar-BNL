import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';

class RepresentativeFormRepo
    extends Repository<$RepresentativesTable, Representative> {
  const RepresentativeFormRepo(super.db);

  @override
  get table => db.representatives;

  Future<bool> checkExistingCedula(int cedula) async =>
      await checkFieldValueAvailable((t) => t.cedula.equals(cedula));

  Future add(RepresentativesCompanion representative) async => await addSingle(
    representative,
    objectName: 'representante',
    uniqueErrorMsg: 'La cédula ya está registrada',
  );
}
