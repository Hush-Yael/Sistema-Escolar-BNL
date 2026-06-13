import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/models/representative_models.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';

class RepresentativesRepo extends Repository {
  const RepresentativesRepo(super.db);

  @override
  $RepresentativesTable get table => db.representatives;

  final companion = RepresentativesCompanion.new;

  Future<List<RepresentativeWithDetails>> getRepresentatives(
    OrderTerms terms,
  ) async {
    final count = db.representativesStudents.id.count();

    final representatives =
        (table.select().join([
            leftOuterJoin(
              db.representativesStudents,
              db.representativesStudents.representativeId.equalsExp(table.id),
            ),
          ])
          ..addColumns([count])
          ..orderBy(
            buildOrderJoined(
              terms,
              otherColumns: {
                RepresentativesTableColumns.studentsCount.name: count,
              },
            ),
          )
          ..groupBy([table.id]));

    return await representatives
        .asyncMap(
          (r) => RepresentativeWithDetails(
            cedula: r.read(table.cedula)!,
            names: r.read(table.names)!,
            lastNames: r.read(table.lastNames)!,
            sex: Sex.values.byName(r.read(table.sex)!),
            id: r.read(table.id)!,
            phone: r.read(table.phone),
            address: r.read(table.address),
            studentsCount: r.read(count)!,
            createdAt: r.read(table.createdAt)!,
            updatedAt: r.read(table.updatedAt)!,
          ),
        )
        .get();
  }

  Future<int> deleteRepresentative(int id) async =>
      await deleteSingle(id, companion, 'No se pudo eliminar el representante');

  Future<int> patch<T>(String field, int id, T newValue) async => patchSingle(
    id,
    field: field,
    fields: RepresentativesTableColumns.values,
    newValue: newValue,
    companion: companion,
    uniqueFailMsg: 'Ya existe un representante con esa cédula',
  );
}
