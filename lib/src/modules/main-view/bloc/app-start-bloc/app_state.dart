part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {}

class AppSetupInProgress extends AppState {}

class AppSetupInComplete extends AppState {}

class AppSetupInFailer extends AppState {
  final String error;

  AppSetupInFailer(this.error);
}
