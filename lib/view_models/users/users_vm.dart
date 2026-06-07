import 'package:disco/disco.dart';
import 'package:sistema_escolar_bnl/core/auth_state.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/repositories/users_repo.dart';
import 'package:sistema_escolar_bnl/shared/table/mixin.dart';
import 'package:sistema_escolar_bnl/view_models/users/mutations_mixin.dart';

class UsersBaseVm with VmTrinaGridMixin {
  final UsersRepository repository;
  final AuthState authState = .instance;

  UsersBaseVm({required this.repository});
}

class UsersVm extends UsersBaseVm with MutationsMixin {
  UsersVm({required super.repository});

  static final instance = Provider((ctx) {
    final AppDatabase db = AppDatabase.instance.of(ctx);
    final usersRepository = UsersRepository(db);

    return UsersVm(repository: usersRepository);
  });
}
