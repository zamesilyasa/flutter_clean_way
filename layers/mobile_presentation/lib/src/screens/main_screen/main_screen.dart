import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:mobile_presentation/src/application.dart';
import 'package:mobile_presentation/src/screens/add_user/add_user.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Center(
        child: BlocBuilder<UsersListBloc, UsersState>(
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
                      MaterialButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddUserPage())),
                        child: Text("Add user"),
                      )
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) =>
                      _UserListItem(state.users[index]),
                );
              }
            } else {
              return Center(
                child: Text("Users loading error"),
              );
            }
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddUserPage()))),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: const Icon(Icons.brightness_6),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User _user;

  _UserListItem(this._user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("User ${_user.id}",
          style: Theme.of(context).textTheme.headline5),
      subtitle: Text(
        "${_user.firstName} ${_user.lastName}",
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<UsersListBloc>().deleteUser(_user);
        },
        icon: Icon(Icons.delete),
      ),
    );
  }
}
