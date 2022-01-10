part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();
  
  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}



class RegisterInProgress extends RegisterState {}

class RegisterInSuccess extends RegisterState {
  final String userId;

  RegisterInSuccess(this.userId);
}

class RegisterInFailer extends RegisterState {
  final String errorMassage;

  RegisterInFailer({this.errorMassage});
}
