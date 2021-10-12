import 'package:domain/entity.dart';

abstract class UserRepository {
  Future<void> addUser(User user);
  Future<void> deleteUser(User user);
  Future<void> updateUser(User user);
  Future<Stream<List<User>>> getUsers();
}