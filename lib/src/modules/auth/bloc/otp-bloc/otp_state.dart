part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {}

class OtpInProgress extends OtpState {}

class OtpSuccess extends OtpState {}

class OtpFaliure extends OtpState {
  final String error;

  const OtpFaliure(this.error);
}

class ReSendingOtpInProgress extends OtpState {}

class ReSendingOtpSuccess extends OtpState {}

class ReSendingOtpFaliure extends OtpState {
  final String error;

  const ReSendingOtpFaliure(this.error);
}
