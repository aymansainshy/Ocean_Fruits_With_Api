import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';
import 'package:ocean_fruits/src/core/config/shared_prefrences_config.dart';
import 'package:ocean_fruits/src/core/utils/prefrences_utils.dart';
import 'package:ocean_fruits/src/modules/auth/models/user.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  OtpBloc(
    // this.userRepository
    ) : super(OtpInitial());
  // final UserRepository userRepository;

  @override
  Stream<OtpState> mapEventToState(OtpEvent event) async* {
    // The Actual Register will done with SENDING OTP .........

    if (event is SendOtp) {
      try {
        yield OtpInProgress();
        final User user = User();
        //= 
        //await userRepository.logInAndRegeister(DataPoster(url: Urls.sendOtpVarifyUrl(event.userId.toString()), data: {"otp": event.otp}));

        if (PreferencesUtils.containsKey(Preferences.user)) {
          PreferencesUtils.remove(Preferences.user);
        }

        PreferencesUtils.setString(Preferences.user, jsonEncode(user.toJson()));

        Application.user = user;

        yield OtpSuccess();
      } on DioError catch(e){
        yield OtpFaliure(e.response.data["code"].toString());
      }catch (e) {
        yield OtpFaliure(e.toString());
      }
    }


    if(event is ReSendOtp){

        try {
        yield ReSendingOtpInProgress();
        final User user = User();
        // await userRepository.logInAndRegeister(DataPoster(url: Urls.reSendOtpUrl(event.userId)));

        // if (PreferencesUtils.containsKey(Preferences.user)) {
        //   PreferencesUtils.remove(Preferences.user);
        // }

        PreferencesUtils.setString(Preferences.user, jsonEncode(user.toJson()));

        Application.user = user;

        yield ReSendingOtpSuccess();
      } on DioError catch(e){
        yield ReSendingOtpFaliure(e.response.data["code"].toString());
      }catch (e) {
        yield ReSendingOtpFaliure(e.toString());
      }

    }
  }
}
