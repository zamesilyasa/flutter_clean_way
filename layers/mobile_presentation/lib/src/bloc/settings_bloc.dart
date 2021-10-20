
import 'package:bloc/bloc.dart';

class SettingsBloc extends Cubit {
  SettingsBloc(initialState) : super(initialState);

}

abstract class SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  // FIXME Not implemented
  // final Settings settings;
  //
  // SettingsLoaded(this.settings);
}