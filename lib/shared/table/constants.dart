import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:trina_grid/trina_grid.dart';

/// [Index] Used to identify the column that contains the index of the row
/// [actions] Used to identify the column that contains the actions of the row
enum TableSpecialCols implements ColumnsEnum {
  // ignore: constant_identifier_names
  Index('#'),
  actions('Acciones');

  const TableSpecialCols(this.title);

  @override
  final String title;
}

final formattedDateColumnType = TrinaColumnType.date(
  format: 'EEE, dd MMM yyyy hh:mm a',
);
