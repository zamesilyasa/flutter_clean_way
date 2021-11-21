
import 'package:bloc/bloc.dart';
import 'package:mobile_presentation/src/storage/settings_storage.dart';

class SettingsBloc extends Cubit<SettingsState> {
  final SettingsStorage _settingsStorage;

  SettingsBloc(this._settingsStorage) : super(SettingsLoading()) {
    _loadSettings();
  }

  Future<void> updateSettings(Settings settings) async {
    _settingsStorage.storeSettings(settings);
  }

  Future<void> _loadSettings() async {
    await for (final settings in _settingsStorage.observeSettings()) {
      emit(SettingsLoaded(settings));
    }
  }
}

abstract class SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;
  SettingsLoaded(this.settings);
}
