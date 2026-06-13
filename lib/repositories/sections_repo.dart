import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/sections_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/school_models.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';

class SectionsRepo extends Repository {
  const SectionsRepo(super.db);

  @override
  get table => db.sections;

  final companion = SectionsCompanion.new;

  Future<List<SectionWithDetails>> getSections(OrderTerms terms) async {
    final studentsCount = db.enrollments.id.count();

    final sections =
        (db.select(db.sections).join([
            leftOuterJoin(
              db.grades,
              db.grades.id.equalsExp(db.sections.gradeId),
              useColumns: false,
            ),
            leftOuterJoin(
              db.enrollments,
              db.enrollments.sectionId.equalsExp(db.sections.id),
              useColumns: false,
            ),
          ])
          ..addColumns([db.grades.name, studentsCount])
          ..orderBy(
            buildOrderJoined(
              terms,
              otherColumns: {
                SectionsTableColumns.grade.name: db.grades.number,
                SectionsTableColumns.studentsCount.name: studentsCount,
              },
            ),
          )
          ..groupBy([db.sections.id]));

    return await sections
        .asyncMap(
          (section) => SectionWithDetails(
            id: section.read<int>(db.sections.id)!,
            letter: section.read<String>(db.sections.letter)!,
            capacity: section.read<int>(db.sections.capacity)!,
            gradeId: section.read<int>(db.sections.gradeId)!,
            gradeName: section.read<String>(db.grades.name)!,
            studentCount: section.read<int>(studentsCount)!,
          ),
        )
        .get();
  }

  Future<int> deleteSection(int id) async =>
      await deleteSingle(id, companion, 'No se pudo eliminar la sección');

  Future<int> updateLetter(int id, String letter) async => await updateSingle(
    id,
    companion,
    companion(letter: Value(letter)),
    defaultFailMsg: 'No se pudo actualizar la sección',
    uniqueFailMsg: 'Ya existe una sección con esa letra',
  );

  Future<int> updateCapacity(int id, int capacity) async => await updateSingle(
    id,
    companion,
    companion(capacity: Value(capacity)),
    defaultFailMsg: 'No se pudo actualizar la sección',
  );

  Future<int> patch<T>(String column, int id, T newValue) async {
    return await patchSingle(
      id,
      field: column,
      fields: SectionsTableColumns.values,
      newValue: newValue,
      companion: companion,
      uniqueFailMsg: column == SectionsTableColumns.letter.name
          ? 'Este grado ya tiene una sección con esa letra'
          : null,
    );
  }
}
