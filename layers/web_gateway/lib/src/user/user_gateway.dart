import 'dart:async';

import 'package:domain/entity.dart';
import 'package:domain/gateway.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

/// The gateway doesn't use any persistence or backend storage, it's too much
/// for the sample project, that's why we store all the data in memory. If you
/// want to store the data in a persistent storage implement it your own way
class WebUserGateway extends UserGateway {
  final _users = <dynamic, User>{};
  final _stream = BehaviorSubject<List<User>>()
    ..add([]);

  @override
  Future<void> addUser(User user) async {
    if (_users.containsKey(user.id)) {
      return Future.error(Exception("User with id is already in stored"));
    }

    final id = Uuid().v1();
    _users[id] = user.copyWith(id: id);
    _stream.add(_users.values.toList());
  }

  @override
  Future<void> deleteUser(User user) async {
    _users.remove(user.id);
    _stream.add(_users.values.toList());
  }

  @override
  Future<void> updateUser(User user) async {
    _users[user.id] = user;
    _stream.add(_users.values.toList());
  }

  @override
  Future<Stream<List<User>>> getUsers() async {
    return _stream.stream;
  }

  void close() {
    _stream.close();
  }
}
