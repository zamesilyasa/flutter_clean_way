import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_presentation/src/bloc/settings_bloc.dart';
import 'package:mobile_presentation/src/screens/main_screen/main_screen.dart';
import 'package:mobile_presentation/src/storage/settings_storage.dart';
import 'package:provider/provider.dart';
import 'package:generic_blocs/generic_blocs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localization/localization.dart';

/// This class contains only the code related to the whole application.
/// It shouldn't contain any code related to particular screens, it only
/// defines things related to the whole application like theming, localization
/// and the things like this
class MobileApplication extends StatelessWidget {
  final GetIt _getIt;

  MobileApplication(GetIt getIt, {Key? key})
      : _getIt = getIt,
        super(key: key) {
    getIt.registerSingleton(SharedPreferences.getInstance());
    getIt.registerSingleton(SettingsStorage(_getIt()));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GetIt>(
      create: (context) => _getIt,
      child: SingletonBlocsProvider(
        getIt: _getIt,
        // Here we subscribe on settings changes, in case anything changes in
        // settings changes, the tree will be rebuilt
        // The same way we subscribe on localization changes or any changes
        // which can affect the whole application
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            if (settingsState is SettingsLoaded) {
              return MaterialApp(
                localizationsDelegates: Localization.localizationsDelegates,
                supportedLocales: Localization.supportedLocales,
                theme: AppTheme.fromSettings(settingsState.settings),
                home: const MainScreen(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

/// This class contains all the possible theme variations. We can have more than
/// two themes if we want
class AppTheme {
  static final themeLight = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    brightness: Brightness.light,
  );

  static final themeDark = ThemeData(
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
  );

  static ThemeData fromSettings(Settings settings) {
    if (settings.currentTheme == CurrentTheme.night) {
      return AppTheme.themeDark;
    } else {
      return AppTheme.themeLight;
    }
  }
}

/// This provider contains all the blocs, which can be accessible from any
/// widget inside the application tree
class SingletonBlocsProvider extends StatelessWidget {
  final GetIt getIt;
  final Widget child;

  const SingletonBlocsProvider({
    Key? key,
    required this.getIt,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      child: child,
      providers: [
        BlocProvider(create: (context) => UsersListBloc(getIt())),
        BlocProvider(create: (context) => SettingsBloc(getIt())),
      ],
    );
  }
}
