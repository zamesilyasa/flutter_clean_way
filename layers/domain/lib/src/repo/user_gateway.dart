import 'package:domain/entity.dart';

abstract class UserGateway {
  Future<void> addUser(User user);
  Future<void> deleteUser(User user);
  Future<void> updateUser(User user);
  Future<Stream<List<User>>> getUsers();
  Future<User?> getUserById(String id);
}