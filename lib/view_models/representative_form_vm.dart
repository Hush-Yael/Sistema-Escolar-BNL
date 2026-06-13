import 'package:disco/disco.dart';
import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/repositories/representative_form_repo.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';
import 'package:sistema_escolar_bnl/shared/mutations/single_add.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';

class RepresentativeFormVm
    extends
        ModalFormWithAsyncValidation<
          RepresentativeFormRepo,
          RepresentativesCompanion
        > {
  RepresentativeFormVm(super.repository);

  static final instance = Provider((context) {
    final db = AppDatabase.instance.of(context);
    final repository = RepresentativeFormRepo(db);

    return RepresentativeFormVm(repository);
  });

  AsyncValidatorResult checkCedulaExists(String value) async {
    final cedula = int.tryParse(value);
    if (cedula == null) return null;

    return await checkFieldAsync(
      value: cedula,
      repoCheckerFn: _cedulaChecker,
      errorMsg: cedulaError,
    );
  }

  final cedulaError = 'La cédula ya está registrada';

  int get _cedula => int.parse(getValue(RepresentativeFormFields.cedula.name));

  @override
  Future<bool> checkAsyncErrorsBeforeSubmit() async {
    final error = await _cedulaChecker(_cedula);

    if (error) {
      getFieldState(RepresentativeFormFields.cedula)!.setError(cedulaError);
    }

    return error;
  }

  @override
  createNewObj() {
    return .insert(
      cedula: _cedula,
      names: getValue<String>(RepresentativeFormFields.names.name),
      lastNames: getValue<String>(RepresentativeFormFields.lastNames.name),
      sex: getValue<Sex>(RepresentativeFormFields.sex.name),
      phone: Value<String>(
        getValue<String>(RepresentativeFormFields.phone.name),
      ),
      address: Value(getValue<String>(RepresentativeFormFields.address.name)),
    );
  }

  @override
  createMutation(context) => createSingleAddMutation(
    .new(
      context,
      queryKey: kRepresentativesKey,
      getStateManager: () => null,
      successName: 'representante',
      unauthPluralName: 'representantes',
      cb: repository.add,
    ),
  );

  late final _cedulaChecker = repository.checkExistingCedula;
}
