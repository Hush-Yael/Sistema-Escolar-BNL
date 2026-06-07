import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';

class Grades extends Table {
  late final id = integer().autoIncrement()();

  late final number = integer().unique()();

  late final name = text().unique()();

  late final shortName = text().unique()();
}

class Sections extends Table {
  late final id = integer().autoIncrement()();

  late final letter = text().withLength(min: 1, max: 1)();

  late final capacity = integer().withDefault(const Constant(30))();

  late final gradeId = integer().references(Grades, #id, onDelete: .restrict)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {letter, gradeId},
  ];
}

class SectionWithDetails extends Section {
  final String gradeName;
  final int studentCount;

  const SectionWithDetails({
    required super.id,
    required super.letter,
    required super.capacity,
    required super.gradeId,
    required this.gradeName,
    required this.studentCount,
  });
}
