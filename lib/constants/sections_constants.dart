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
