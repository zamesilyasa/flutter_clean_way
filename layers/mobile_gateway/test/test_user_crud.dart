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
      gateway = MobileUserGateway(Future.value(db), CursorItemToUserMapper());
      UserTable.create(db);
    });
    tearDown(() async {
      await db.close();
    });
    test("Creates user record", () async {
      await gateway.addUser(User("fn", "ln", "test@test.com"));
      final list = await (await gateway.getUsers()).first;

      expect(list.first.email, "test@test.com");
    });

    test("Deletes user record", () async {
      final user = await gateway.addUser(User("fn", "ln", "test@test.com"));
      await gateway.deleteUser(user);

      final usersStream = await gateway.getUsers();
      // First value of the stream is always empty list
      expect((await usersStream.first).length, 0);
    });

    test("Updates user record", () async {
      final user = await gateway.addUser(User("fn", "ln", "test@test.com"));

      await gateway.updateUser(user.copyWith(firstName: "updated first name"));
      final list = await (await gateway.getUsers()).first;

      expect(list.first.firstName, "updated first name");
    });
  });
}
