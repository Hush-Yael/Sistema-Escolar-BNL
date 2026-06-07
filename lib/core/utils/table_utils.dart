import 'package:trina_grid/trina_grid.dart';

extension TrinaRowExt on TrinaRow {
  /// returns the id (if provided) of the object associated with the row
  int get $id {
    if (metadata == null) {
      throw Exception('Row metadata was not defined');
    }

    if (!metadata!.containsKey('id')) {
      throw Exception('Row metadata does not contain "id" key');
    }

    return metadata!['id'];
  }

  set $id(int id) => metadata!['id'] = id;

  T cellValue<T extends dynamic>(String field) => cells[field]?.originalValue;
}
