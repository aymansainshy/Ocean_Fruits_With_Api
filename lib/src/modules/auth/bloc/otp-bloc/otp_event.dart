part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();

  @override
  List<Object> get props => [];
}

class SendOtp extends OtpEvent {
  final String otp;
  final String userId;

  SendOtp(this.otp, this.userId);
}

class ReSendOtp extends OtpEvent {
  final String userId;

  ReSendOtp(this.userId);
}

