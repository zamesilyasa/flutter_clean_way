import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:mobile_presentation/src/bloc/settings_bloc.dart';
import 'package:mobile_presentation/src/screens/add_user/add_user.dart';
import 'package:mobile_presentation/src/storage/settings_storage.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Center(
        child: BlocBuilder<UsersListBloc, UsersState>(
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
                      const Text("The list is empty"),
                      MaterialButton(
                        onPressed: () =>
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddUserPage())),
                        child: const Text("Add user"),
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
              return const Center(
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
                onPressed: () =>
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => const AddUserPage()))),
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              if (settingsState is SettingsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: FloatingActionButton(
                    child: const Icon(Icons.brightness_6),
                    onPressed: () {
                      if (settingsState.settings.currentTheme ==
                          CurrentTheme.night) {
                        context.read<SettingsBloc>().updateSettings(
                            settingsState.settings.copyWith(
                                currentTheme: CurrentTheme.day));
                      } else {
                        context.read<SettingsBloc>().updateSettings(
                            settingsState.settings.copyWith(
                                currentTheme: CurrentTheme.night));
                      }
                    },
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User _user;

  const _UserListItem(this._user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("User ${_user.id}",
          style: Theme
              .of(context)
              .textTheme
              .headline5),
      subtitle: Text(
        "${_user.firstName} ${_user.lastName}",
      ),
      trailing: IconButton(
        onPressed: () {
          context.read<UsersListBloc>().deleteUser(_user);
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
