import 'package:trina_grid/trina_grid.dart';

extension TrinaRowExt on TrinaRow {
  /// returns the id (if provided) of the object associated with the row
  int? get $id => data?['id'];

  set $id(int? id) => data?['id'] = id;

  T cellValue<T extends dynamic>(String field) => cells[field]?.originalValue;
}
