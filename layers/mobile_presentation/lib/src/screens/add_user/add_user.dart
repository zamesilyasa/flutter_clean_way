import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:generic_blocs/generic_blocs.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

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
    return Scaffold(
      key: const Key("Add user page"),
      appBar: AppBar(
        title: const Text("Add new user"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "First name should not be empty";
                  }
                },
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
                decoration: const InputDecoration(
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
