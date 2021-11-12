import 'package:domain/entity.dart';
import 'package:mobile_gateway/src/database.dart';
import 'package:mobile_gateway/src/user/user_gateway.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

main() {
  group("users table CRUD operations", () {
    late Database db;
    late MobileUserGateway gateway;

    sqfliteFfiInit();
    setUp(() async {
      db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      gateway = MobileUserGateway(Future.value(db));
      UserTable.create(db);
    });
    tearDown(() async {
      await db.close();
    });
    test('simple sqflite example', () async {
      expect(await db.getVersion(), 0);
      await db.close();
    });

    test("Creates user record", () async {
      await gateway.addUser(User(null, "fn", "ln", "test@test.com"));
      final list = await (await gateway.getUsers()).skip(1).first;

      expect(list.first.email, "test@test.com");
    });

    test("Deletes user record", () async {
      await gateway.addUser(User(null, "fn", "ln", "test@test.com"));
      final list = await (await gateway.getUsers()).skip(1).first;

      expect(list.first.email, "test@test.com");
    });
  });
}
