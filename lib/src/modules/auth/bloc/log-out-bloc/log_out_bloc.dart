import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';
import 'package:ocean_fruits/src/core/config/shared_prefrences_config.dart';
import 'package:ocean_fruits/src/core/utils/prefrences_utils.dart';

part 'log_out_event.dart';
part 'log_out_state.dart';

class LogOutBloc extends Bloc<LogOutEvent, LogOutState> {
  LogOutBloc() : super(LogOutInitial());

  @override
  Stream<LogOutState> mapEventToState(LogOutEvent event) async* {
    if (event is LogMeOute) {
      try {
        yield LogOutInProgress();

        if (PreferencesUtils.containsKey(Preferences.user)) {
          PreferencesUtils.remove(Preferences.user);

          await Future.delayed(const Duration(milliseconds: 3000));

          Application.user = null;

          yield LogOutSuccess();
        }
        
      } catch (e) {
        yield const LogOutFailure();
      }
    }
  }
}
