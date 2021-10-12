import 'dart:async';

import 'package:domain/entity.dart';
import 'package:domain/repository.dart';
import 'package:uuid/uuid.dart';

class DataUserRepository extends UserRepository {
  final _users = <dynamic, User>{};
  final _stream = StreamController<List<User>>.broadcast();
  late Sink<List<User>> _usersSink = _stream.sink;

  @override
  Future<void> addUser(User user) async {
    if (_users.containsKey(user.id)) {
      return Future.error(Exception("User with id is already in stored"));
    }

    final id = Uuid();
    _users[id] = user.copyWith(id: id);
    _usersSink.add(_users.values.toList());
  }

  @override
  Future<void> deleteUser(User user) async {
    _users.remove(user.id);
    _usersSink.add(_users.values.toList());
  }

  @override
  Future<void> updateUser(User user) async {
    _users[user.id] = user;
    _usersSink.add(_users.values.toList());
  }

  @override
  Future<Stream<List<User>>> getUsers() async {
    return _stream.stream;
  }

  void close() {
    _usersSink.close();
    _stream.close();
  }
}
