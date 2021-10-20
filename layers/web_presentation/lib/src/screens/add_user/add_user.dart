import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:provider/provider.dart';

class AddUserPage extends StatefulWidget {
  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  String _firstName = "";
  String _lastName = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("New user"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "First name should not be empty";
                }
              },
              decoration: InputDecoration(
                labelText: "First name",
              ),
              onChanged: (text) => _firstName = text,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Last name should not be empty";
                }
              },
              decoration: InputDecoration(
                labelText: "Last name",
              ),
              onChanged: (text) => _lastName = text,
            ),
            TextFormField(
              validator: (value) {
                if (!value.isEmailAddress()) {
                  return "Doesn't look like email address";
                }
              },
              decoration: InputDecoration(
                labelText: "Email address",
              ),
              onChanged: (text) => _email = text,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      context.read<UsersListBloc>().addUser(
                        _firstName,
                        _lastName,
                        _email,
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("SAVE")),
            )
          ],
        ),
      ),
    );
  }
}

extension EmailValidator on String? {
  bool isEmailAddress() {
    if (this == null) {
      return false;
    } else {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!);
    }
  }
}