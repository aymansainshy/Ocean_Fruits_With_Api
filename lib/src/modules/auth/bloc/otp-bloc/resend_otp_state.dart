
// ReSending Otp ......
part of 'otp_bloc.dart';

class ReSendingOtpInProgress extends OtpState {}

class ReSendingOtpSuccess extends OtpState {}

class ReSendingOtpFaliure extends OtpState {
  final String error;

  const ReSendingOtpFaliure(this.error);
}