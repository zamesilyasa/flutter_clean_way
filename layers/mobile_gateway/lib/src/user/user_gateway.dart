import 'dart:async';

import 'package:domain/entity.dart';
import 'package:domain/gateway.dart';
import 'package:mobile_gateway/src/database.dart' as tables show UserTable;
import 'package:rxdart/rxdart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';

class MobileUserGateway extends UserGateway {
  final Future<Database> _db;
  final CursorItemToUserMapper _mapper;
  final _stream = BehaviorSubject<List<User>>();

  MobileUserGateway(
    this._db,
    this._mapper,
  );

  @override
  Future<User> addUser(User user) async {
    print("Adding user $user");
    final id = await (await _db).insert(tables.UserTable.tableName, {
      tables.UserTable.firstName: user.firstName,
      tables.UserTable.lastName: user.lastName,
      tables.UserTable.email: user.email,
    });

    await _syncStream();
    return _stream.value.firstWhere((u) => u.id == id.toString());
  }

  @override
  Future<void> deleteUser(User user) async {
    await (await _db).delete(tables.UserTable.tableName,
        where: "${tables.UserTable.id} == ${user.id}");
    await _syncStream();
  }

  @override
  Future<void> updateUser(User user) async {
    if (user.id == null) {
      return Future.error(Exception("User doesn't have id"));
    }

    await (await _db).update(tables.UserTable.tableName, {
      tables.UserTable.id: user.id,
      tables.UserTable.firstName: user.firstName,
      tables.UserTable.lastName: user.lastName,
      tables.UserTable.email: user.email,
    });
    await _syncStream();
  }

  @override
  Future<Stream<List<User>>> getUsers() async {
    if (!_stream.hasValue) {
      await _syncStream();
    }
    return _stream.stream;
  }

  Future<void> _syncStream() async {
    final result = await (await _db).query(tables.UserTable.tableName);
    final users = result.map<User>((it) {
      return _mapper(it);
    }).toList();

    _stream.add(users);
  }

  void close() {
    _stream.close();
  }

  @override
  Future<User?> getUserById(String id) async {
    final Cursor result = await (await _db).query(tables.UserTable.tableName,
        where: "${tables.UserTable.id}=?", whereArgs: [id]);

    if (result.isEmpty) {
      return null;
    } else {
      return _mapper(result.first);
    }
  }
}

class CursorItemToUserMapper {
  User call(CursorItem item) {
    return User(
      item[tables.UserTable.firstName] as String,
      item[tables.UserTable.lastName] as String,
      item[tables.UserTable.email] as String,
      id: item[tables.UserTable.id].toString(),
    );
  }
}
