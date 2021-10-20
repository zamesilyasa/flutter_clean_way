import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_presentation/src/screens/main_screen/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:generic_blocs/generic_blocs.dart';

class MobileApplication extends StatelessWidget {
  final GetIt _getIt;

  MobileApplication(GetIt getIt) : _getIt = getIt;

  @override
  Widget build(BuildContext context) {
    return Provider<GetIt>(
      create: (context) => _getIt,
      child: SingletonBlocsProvider(
        getIt: _getIt,
        child: BlocProvider(
          create: (_) => ThemeCubit(),
          child: BlocBuilder<ThemeCubit, ThemeData>(
            builder: (_, theme) => MaterialApp(
              theme: theme,
              home: MainScreen(),
            ),
          ),
        ),
      )
    );
  }
}

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(_lightTheme);

  static final _lightTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final _darkTheme = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}

class SingletonBlocsProvider extends StatelessWidget {
  final GetIt getIt;
  final Widget child;

  SingletonBlocsProvider({
    required this.getIt,
    required this.child,
  });

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
