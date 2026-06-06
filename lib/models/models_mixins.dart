import 'package:drift/drift.dart';

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

const kNamesMinLength = 3;
const kNamesMaxLength = 64;

mixin Person on Table {
  late final cedula = integer().unique()();

  late final names = text().withLength(
    min: kNamesMinLength,
    max: kNamesMaxLength,
  )();

  late final lastNames = text().withLength(
    min: kNamesMinLength,
    max: kNamesMaxLength,
  )();

  late final sex = textEnum<Sex>()();
}
