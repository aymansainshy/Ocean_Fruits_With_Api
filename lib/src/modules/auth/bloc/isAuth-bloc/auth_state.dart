part of 'auth_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationInProgress extends AuthenticationState {}

class AuthenticationInFailure extends AuthenticationState {}

enum AuthStatus { authenticated, unknown }

class AuthenticationSuccsess extends AuthenticationState {
  final AuthStatus status;

 const AuthenticationSuccsess({this.status = AuthStatus.unknown});

  AuthenticationSuccsess copyWith(AuthStatus status) => AuthenticationSuccsess(
        status: status ?? this.status,
      );
}
