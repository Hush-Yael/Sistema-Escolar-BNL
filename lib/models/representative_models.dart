import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/representative_constants.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/models/models_mixins.dart';
import 'package:sistema_escolar_bnl/models/student_models.dart';

class Representatives extends Table with Person, Timestamps {
  late final id = integer().autoIncrement()();

  late final phone = text().nullable().withLength(
    min: kPhoneMinLength,
    max: kPhoneMaxLength,
  )();

  late final address = text().nullable().withLength(
    min: kAddressMinLength,
    max: kAddressMaxLength,
  )();
}

@DataClassName('StudentRepresentativeRelation')
class RepresentativesStudents extends Table {
  late final id = integer().autoIncrement()();

  late final representativeId = integer().references(
    Representatives,
    #id,
    onDelete: .cascade,
  )();

  late final studentId = integer().references(
    Students,
    #id,
    onDelete: .cascade,
  )();
}

class RepresentativeWithDetails extends Representative {
  final int studentsCount;

  RepresentativeWithDetails({
    required super.cedula,
    required super.names,
    required super.lastNames,
    required super.sex,
    required super.id,
    required super.phone,
    required super.address,
    required this.studentsCount,
    required super.createdAt,
    required super.updatedAt,
  });
}
