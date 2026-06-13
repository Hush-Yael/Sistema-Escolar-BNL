import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sistema_escolar_bnl/core/utils/validators.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';

const kPhoneMinLength = 10;
const kPhoneMaxLength = 15;

const kAddressMinLength = 10;
const kAddressMaxLength = 255;

const kRepresentativesKey = ['representatives'];

enum RepresentativesTableColumns implements ColumnsEnum {
  cedula('Cédula'),
  names('Nombres'),
  lastNames('Apellidos'),
  phone('Teléfono'),
  address('Dirección'),
  studentsCount('Estudiantes');

  const RepresentativesTableColumns(this.title);

  @override
  final String title;
}

enum RepresentativeFormFields { cedula, names, lastNames, phone, address, sex }

class RepresentativeValidators {
  static final phone = Validators.notRequired(
    FormBuilderValidators.compose([
      FormBuilderValidators.match(
        RegExp(r'^\+?\d[\d-]*$'),
        errorText: 'El teléfono debe contener solo números y un formato válido',
      ),
      Validators.minLength(kPhoneMinLength),
      Validators.maxLength(kPhoneMaxLength),
    ]),
  );

  static final address = Validators.notRequired(
    FormBuilderValidators.compose([
      Validators.minLength(kAddressMinLength),
      Validators.maxLength(kAddressMaxLength),
    ]),
  );
}
