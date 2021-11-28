import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/generated/l10n.dart';
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
        title: Text(Strings.of(context).addNewUser),
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
                    return Strings.of(context).firstNameShouldNotBeEmpty;
                  }
                },
                decoration: InputDecoration(
                  labelText: Strings.of(context).firstName,
                ),
                onChanged: (text) => _firstName = text,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Strings.of(context).lastNameShouldNotBeEmpty;
                  }
                },
                decoration: InputDecoration(
                  labelText: Strings.of(context).lastName,
                ),
                onChanged: (text) => _lastName = text,
              ),
              TextFormField(
                validator: (value) {
                  if (!value.isEmailAddress()) {
                    return Strings.of(context).emailAddressFormatError;
                  }
                },
                decoration: InputDecoration(
                  labelText: Strings.of(context).emailAddress,
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
                    child: Text(Strings.of(context).save)),
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
