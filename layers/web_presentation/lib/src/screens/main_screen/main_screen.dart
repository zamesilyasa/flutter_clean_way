import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:provider/provider.dart';
import 'package:web_presentation/src/screens/add_user/add_user.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              "Users web page!",
              style: Theme.of(context).textTheme.headline2!.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          BlocBuilder<UsersListBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UsersIdle) {
                context.read<UsersListBloc>().loadUsers();
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UsersLoaded) {
                if (state.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("The list is empty"),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () => showAddUserPage(context),
                              child: const Text("add user")),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(
                              "email",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(label: Text("first name", style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("last name", style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("id", style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(fontWeight: FontWeight.bold),)),
                          DataColumn(label: Text("")),
                        ],
                        rows: createTableRows(state.users, context),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text("Users loading error"),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<DataRow> createTableRows(List<User> users, BuildContext context) {
    final rows = users
        .map((user) => DataRow(cells: [
              DataCell(Text(user.email)),
              DataCell(Text(user.firstName)),
              DataCell(Text(user.lastName)),
              DataCell(Text(user.id ?? "N/A")),
              DataCell(IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  context.read<UsersListBloc>().deleteUser(user);
                },
              ))
            ]))
        .toList();

    rows.add(DataRow(cells: [
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(SizedBox()),
      DataCell(ElevatedButton(
          onPressed: () => showAddUserPage(context),
          child: const Text("add user")))
    ]));

    return rows;
  }

  showAddUserPage(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog(
        context: context,
        builder: (context) => AddUserPage()
      );
    });
  }
}
