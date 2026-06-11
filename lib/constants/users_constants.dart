import 'package:sistema_escolar_bnl/shared/table/columns.dart';
import 'package:sistema_escolar_bnl/types/shared_types.dart';

const QueryKey kUsersQueryKey = ['users'];

enum UsersTableColumns implements ColumnsEnum {
  name('Nombre'),
  username('Nombre de usuario'),
  role('Rol'),
  lastLogin('Último ingreso');

  const UsersTableColumns(this.title);

  @override
  final String title;
}
