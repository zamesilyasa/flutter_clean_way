import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:web_presentation/src/screens/main_screen/main_screen.dart';

class WebApplication extends StatelessWidget {
  final GetIt _getIt;

  const WebApplication(GetIt getIt, {Key? key})
      : _getIt = getIt,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<GetIt>(
        create: (context) => _getIt,
        child: SingletonBlocsProvider(
          getIt: _getIt,
          child: MaterialApp(
            localizationsDelegates: Localization.localizationsDelegates,
            supportedLocales: Localization.supportedLocales,
            home: const MainScreen(),
          ),
        ));
  }
}

class SingletonBlocsProvider extends StatelessWidget {
  final GetIt getIt;
  final Widget child;

  const SingletonBlocsProvider({Key? key,
    required this.getIt,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      child: child,
      providers: [
        BlocProvider(create: (context) => UsersListBloc(getIt())),
      ],
    );
  }
}
