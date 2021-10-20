import 'package:sqflite/sqflite.dart';

class User {
  static final String tableName = "user";
  static final String id = "id";
  static final String firstName = "first_name";
  static final String lastName = "last_name";
  static final String email = "email";
}

Future<Database> initDatabase() async =>
    openDatabase("db.sqlite", version: 1, onCreate: (db, version) {
      db.execute('CREATE TABLE IF NOT EXISTS ${User.tableName}('
          '${User.id} INTEGER PRIMARY KEY AUTOINCREMENT, '
          '${User.firstName} TEXT, '
          '${User.lastName} TEXT, '
          '${User.email} TEXT '
          ')');
    });
