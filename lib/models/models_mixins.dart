import 'package:drift/drift.dart';
import 'package:sistema_escolar_bnl/constants/shared_constants.dart';

mixin Timestamps on Table {
  late final createdAt = dateTime().withDefault(currentDateAndTime)();

  late final updatedAt = dateTime().withDefault(currentDateAndTime)();
}

enum Sex {
  f('Femenino'),
  m('Masculino');

  const Sex(this.label);

  final String label;
}

mixin Person on Table {
  late final cedula = integer().unique()();

  late final names = text().withLength(
    min: kNameMinLength,
    max: kNameMaxLength,
  )();

  late final lastNames = text().withLength(
    min: kNameMinLength,
    max: kNameMaxLength,
  )();

  late final sex = textEnum<Sex>()();
}
