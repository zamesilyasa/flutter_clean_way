import '../../entity.dart';
import '../../repository.dart';

class AddUserUseCase {
  final UserRepository _userRepository;

  AddUserUseCase(this._userRepository);

  Future<void> call(User user) async {
    _userRepository.addUser(user);
  }
}

class DeleteUserUseCase {
  final UserRepository _userRepository;

  DeleteUserUseCase(this._userRepository);

  Future<void> call(User user) async {
    _userRepository.deleteUser(user);
  }
}

class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  Future<void> call(User user) async {
    _userRepository.updateUser(user);
  }
}