import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';

class UsersListBloc extends Cubit<UsersState> {
  final UserGateway userGateway;

  UsersListBloc(this.userGateway) : super(UsersIdle());

  Future<void> loadUsers() async {
    print("Loading users");
    emit(UsersLoading());
    final stream = await userGateway.getUsers();
    print("Listening for stream");
    await for (final users in stream) {
      print("Stream result $users");
      emit(UsersLoaded(users));
    }
  }

  Future<void> addUser(String firstName, String lastName, String email) async {
    userGateway.addUser(User(null, firstName, lastName, email));
  }

  Future<void> deleteUser(User user) async {
    userGateway.deleteUser(user);
  }

  Future<void> updateUser(User user) async {
    userGateway.updateUser(user);
  }
}

class UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;

  UsersLoaded(this.users);
}

class UsersIdle extends UsersState {}

class UsersError extends UsersState {}
