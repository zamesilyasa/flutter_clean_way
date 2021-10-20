import 'dart:async';

import 'package:domain/entity.dart';
import 'package:domain/repository.dart';
import 'package:mobile_gateway/src/database.dart' as db show User;
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class MobileUserGateway extends UserGateway {
  final Future<Database> _db;
  final _stream = BehaviorSubject<List<User>>.seeded([]);

  MobileUserGateway(this._db);

  @override
  Future<void> addUser(User user) async {
    print("Adding user $user");
    final id = Uuid();
    await (await _db).insert(db.User.tableName, {
      db.User.firstName: user.firstName,
      db.User.lastName: user.lastName,
      db.User.email: user.email,
    });

    _syncStream();
  }

  @override
  Future<void> deleteUser(User user) async {
    await (await _db).delete(db.User.tableName, where: "${db.User.id} == ${user.id}");
    _syncStream();
  }

  @override
  Future<void> updateUser(User user) async {
    await (await _db).update(db.User.tableName, {
      db.User.firstName: user.firstName,
      db.User.lastName: user.lastName,
      db.User.email: user.email,
    });
    _syncStream();
  }

  @override
  Future<Stream<List<User>>> getUsers() async {
    _syncStream();
    return _stream.stream;
  }

  Future<void> _syncStream() async {
    final result = await (await _db).query(db.User.tableName);
    final users = result.map<User>((it) {
      return User(
        it[db.User.id],
        it[db.User.firstName] as String,
        it[db.User.lastName] as String,
        it[db.User.email] as String,
      );
    }).toList();

    _stream.add(users);
  }

  void close() {
    _stream.close();
  }
}
