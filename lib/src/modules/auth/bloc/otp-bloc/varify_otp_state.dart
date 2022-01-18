// Varify Otp ......
part of 'otp_bloc.dart';

class VarifyOtpInProgress extends OtpState {}

class VarifyOtpSuccess extends OtpState {}

class VarifyOtpFaliure extends OtpState {
  final String error;

  const VarifyOtpFaliure(this.error);
}
