import '../../entity.dart';
import '../../gateway.dart';

class AddUserUseCase {
  final UserGateway _userGateway;

  AddUserUseCase(this._userGateway);

  Future<void> call(User user) async {
    _userGateway.addUser(user);
  }
}

class DeleteUserUseCase {
  final UserGateway _userGateway;

  DeleteUserUseCase(this._userGateway);

  Future<void> call(User user) async {
    _userGateway.deleteUser(user);
  }
}

class UpdateUserUseCase {
  final UserGateway _userGateway;

  UpdateUserUseCase(this._userGateway);

  Future<void> call(User user) async {
    _userGateway.updateUser(user);
  }
}