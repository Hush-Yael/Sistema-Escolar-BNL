import 'package:trina_grid/trina_grid.dart';

/// Used to identify the column that contains the index of the row
const kIndexColumnField = 'index';

/// Used to identify the column that contains the actions of the row
const kActionsColumnName = 'actions';

final formattedDateColumnType = TrinaColumnType.date(
  format: 'EEE, dd MMM yyyy hh:mm a',
);
