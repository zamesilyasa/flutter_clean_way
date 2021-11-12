import 'package:sqflite/sqflite.dart';

class UserTable {
  static final String tableName = "user";
  static final String id = "id";
  static final String firstName = "first_name";
  static final String lastName = "last_name";
  static final String email = "email";

  UserTable._();

  static Future<void> create(Database db) async {
    db.execute('CREATE TABLE IF NOT EXISTS $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$firstName TEXT, '
        '$lastName TEXT, '
        '$email TEXT '
        ')');
  }
}

Future<Database> initDatabase() async =>
    openDatabase("db.sqlite", version: 1, onCreate: (db, version) {
      UserTable.create(db);
    });
