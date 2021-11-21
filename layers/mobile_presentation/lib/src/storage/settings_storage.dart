
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {

  final Future<SharedPreferences> _sharedPreferences;
  final _settings = BehaviorSubject<Settings>();
  final _defaultTheme = CurrentTheme.day;

  SettingsStorage(this._sharedPreferences) {
    _readTheme();
  }

  Future<void> storeSettings(Settings settings) async {
    final prefs = await _sharedPreferences;
    prefs.setInt("theme", settings.currentTheme.index);
    _readTheme();
  }

  Stream<Settings> observeSettings() {
    return _settings;
  }

  Settings? getSettings() => _settings.valueOrNull;

  Future<void> close() async {
    return _settings.close();
  }

  Future<void> _readTheme() async {
    final prefs = await _sharedPreferences;
    try {
      final themeInt = prefs.getInt("theme");
      if (themeInt == null) {
        _settings.add(Settings(_defaultTheme));
      } else {
        _settings.add(Settings(CurrentTheme.values[themeInt]));
      }
    } catch (e) {
      _settings.add(Settings(_defaultTheme));
    }
  }
}

class Settings {
  final CurrentTheme currentTheme;

  Settings(this.currentTheme);

  Settings copyWith({CurrentTheme? currentTheme}) {
    return Settings(currentTheme ?? this.currentTheme);
  }
}

enum CurrentTheme {
  day, night,
}
