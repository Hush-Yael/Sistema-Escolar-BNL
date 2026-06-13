import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sistema_escolar_bnl/core/utils/validators.dart';
import 'package:sistema_escolar_bnl/shared/table/columns.dart';

const kSectionsKey = ['grades'];

enum SectionsTableColumns implements ColumnsEnum {
  grade('Grado'),
  letter('Letra'),
  capacity('Capacidad'),
  studentsCount('Estudiantes'),
  enrollment('Matrícula');

  const SectionsTableColumns(this.title);

  @override
  final String title;
}

class SectionValidators {
  static final letter = FormBuilderValidators.compose([
    Validators.required,
    FormBuilderValidators.match(
      RegExp(r'^[A-Za-zñÑ]$'),
      errorText: 'Se esperaba una letra',
    ),
  ]);

  static final capacity = FormBuilderValidators.compose([
    Validators.required,
    FormBuilderValidators.min(1, errorText: 'La capacidad debe ser mayor a 0'),
  ]);
}
