import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

/// Performs user stream loading

class UserCubitState {}

class Loading extends UserCubitState {}

class Loaded extends UserCubitState {
  final List<User> users;

  Loaded(this.users);
}

class Idle extends UserCubitState {}

class Error extends UserCubitState {}

class UserListCubit extends Cubit<UserCubitState> {
  final UserRepository userRepository;

  UserListCubit(this.userRepository) : super(Idle());

  Future<void> loadUsers() async {
    emit(Loading());
    userRepository
        .getUsers()
        .then((stream) async {
      await for (final users in stream) {
        emit(Loaded(users));
      }
    });
  }

  Future<void> addUser(String firstName, String lastName, String email) async {
    userRepository.addUser(User(null, firstName, lastName, email));
  }

  Future<void> deleteUser(User user) async {
    userRepository.deleteUser(user);
  }

  Future<void> updateUser(User user) async {
    userRepository.updateUser(user);
  }
}