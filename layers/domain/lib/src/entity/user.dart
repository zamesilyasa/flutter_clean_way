import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final String? id;
  final String firstName;
  final String lastName;
  final String email;

  const User(
    this.firstName,
    this.lastName,
    this.email, {
    this.id,
  });

  @override
  List<Object?> get props => [firstName, lastName, email];

  @override
  bool get stringify => true;

  User copyWith({
    String? id,
    firstName,
    lastName,
    email,
  }) => User(
      firstName ?? this.firstName,
      lastName ?? this.lastName,
      email ?? this.email,
      id: id ?? this.id
  );
}
