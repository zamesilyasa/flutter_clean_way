import 'package:equatable/equatable.dart';

class User with EquatableMixin {
  final dynamic id;
  final String firstName;
  final String lastName;
  final String email;

  const User(
    this.id,
    this.firstName,
    this.lastName,
    this.email,
  );

  @override
  List<Object?> get props => [firstName, lastName, email];

  @override
  bool get stringify => true;

  User copyWith({dynamic id}) =>
      User(id, firstName, lastName, email);
}
