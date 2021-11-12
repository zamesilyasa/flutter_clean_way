import 'dart:async';

import 'package:domain/entity.dart';
import 'package:domain/gateway.dart';
import 'package:mobile_gateway/src/database.dart' as db show UserTable;
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
    await (await _db).insert(db.UserTable.tableName, {
      db.UserTable.firstName: user.firstName,
      db.UserTable.lastName: user.lastName,
      db.UserTable.email: user.email,
    });

    _syncStream();
  }

  @override
  Future<void> deleteUser(User user) async {
    await (await _db).delete(db.UserTable.tableName, where: "${db.UserTable.id} == ${user.id}");
    _syncStream();
  }

  @override
  Future<void> updateUser(User user) async {
    await (await _db).update(db.UserTable.tableName, {
      db.UserTable.firstName: user.firstName,
      db.UserTable.lastName: user.lastName,
      db.UserTable.email: user.email,
    });
    _syncStream();
  }

  @override
  Future<Stream<List<User>>> getUsers() async {
    _syncStream();
    return _stream.stream;
  }

  Future<void> _syncStream() async {
    final result = await (await _db).query(db.UserTable.tableName);
    final users = result.map<User>((it) {
      return User(
        it[db.UserTable.id],
        it[db.UserTable.firstName] as String,
        it[db.UserTable.lastName] as String,
        it[db.UserTable.email] as String,
      );
    }).toList();

    _stream.add(users);
  }

  void close() {
    _stream.close();
  }
}
