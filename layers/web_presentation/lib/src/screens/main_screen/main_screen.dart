import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:localization/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:web_presentation/src/screens/add_user/add_user.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              Strings.of(context).usersWebPage,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          BlocBuilder<UsersListBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UsersIdle) {
                context.read<UsersListBloc>().loadUsers();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is UsersLoaded) {
                if (state.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Strings.of(context).usersListEmpty),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                              onPressed: () => showAddUserPage(context),
                              child: Text(Strings.of(context).addUser)),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                              label: Text(
                            Strings.of(context).emailAddress,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            Strings.of(context).firstName,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            Strings.of(context).lastName,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                          DataColumn(
                              label: Text(
                            "id",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                          const DataColumn(label: Text("")),
                        ],
                        rows: createTableRows(state.users, context),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: Text(Strings.of(context).usersLoadingError),
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
              DataCell(Text(user.id ?? Strings.of(context).na)),
              DataCell(IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<UsersListBloc>().deleteUser(user);
                },
              ))
            ]))
        .toList();

    rows.add(DataRow(cells: [
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      const DataCell(SizedBox()),
      DataCell(ElevatedButton(
          onPressed: () => showAddUserPage(context),
          child: Text(Strings.of(context).addUser)))
    ]));

    return rows;
  }

  showAddUserPage(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog(context: context, builder: (context) => const AddUserPage());
    });
  }
}
