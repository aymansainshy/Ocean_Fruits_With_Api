import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is OnAuthInit) {
      try {
        yield AuthenticationInProgress();

        if (Application.user != null) {
          yield const AuthenticationSuccsess(status: AuthStatus.authenticated);
        } else {
          yield AuthenticationInFailure();
        }
      } catch (e) {
        // print("Authenticatted Faild ... ");
        yield AuthenticationInFailure();
      }
    }
  }
}
