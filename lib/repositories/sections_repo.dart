import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/school_models.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';

class SectionsRepo extends Repository {
  const SectionsRepo(super.db);

  @override
  get table => db.sections;

  final companion = SectionsCompanion.new;

  Future<List<SectionWithDetails>> getSections() async {
    final count = db.enrollments.id.count();

    final sections =
        await (db.select(db.sections).join([
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
              ..addColumns([db.grades.name, count])
              ..groupBy([db.sections.id]))
            .asyncMap(
              (section) => SectionWithDetails(
                id: section.read<int>(db.sections.id)!,
                letter: section.read<String>(db.sections.letter)!,
                capacity: section.read<int>(db.sections.capacity)!,
                gradeId: section.read<int>(db.sections.gradeId)!,
                gradeName: section.read<String>(db.grades.name)!,
                studentCount: section.read<int>(count)!,
              ),
            )
            .get();

    return sections;
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
}
