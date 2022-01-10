part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterMe extends RegisterEvent {
  final Map<String, dynamic> registerData;

  RegisterMe({this.registerData});
}
