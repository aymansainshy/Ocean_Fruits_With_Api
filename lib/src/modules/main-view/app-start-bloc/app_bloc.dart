import 'dart:async';
import 'dart:convert';

import 'package:ocean_fruits/app_blocs.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';
import 'package:ocean_fruits/src/core/config/shared_prefrences_config.dart';
import 'package:ocean_fruits/src/core/utils/prefrences_utils.dart';
import 'package:ocean_fruits/src/modules/auth/bloc/isAuth-bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';


part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial());

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppStarted) {
      yield AppSetupInProgress();
      

      Application.preferences = await SharedPreferences.getInstance();

      // PreferencesUtils.clear();


      ///Read/Save Device Information
      // Device device;
      // try {
      //   if (Platform.isAndroid) {
      //     final android = await deviceInfoPlugin.androidInfo;
      //     device = Device(
      //       uuid: android.androidId,
      //       name: "Android",
      //       model: android.model,
      //       version: android.version.sdkInt.toString(),
      //       type: android.type,
      //     );
      //   } else if (Platform.isIOS) {
      //     final IosDeviceInfo ios = await deviceInfoPlugin.iosInfo;
      //     device = Device(
      //       uuid: ios.identifierForVendor,
      //       name: ios.name,
      //       model: ios.systemName,
      //       version: ios.systemVersion,
      //       type: ios.utsname.machine,
      //     );
      //   }
      // } catch (e) {
      //   print("Device setup error $e");
      // }

      // Application.device = device;

      //Change locale if exist in shearedPreference ...
      // if (PreferencesUtils.containsKey(Preferences.language)) {
      //   String languageCode = PreferencesUtils.getString(Preferences.language);
      //   int languageVal = PreferencesUtils.getInt(Preferences.langVal);

      //   AppBlocs.languageBloc.add(
      //     ChangeLanguage(
      //       selectedVal: languageVal,
      //       locale: Locale(languageCode),
      //     ),
      //   );
      // }

      //Add locale if does not  exist in shearedPreference ...
      // if (!PreferencesUtils.containsKey(Preferences.language)) {
      //   AppBlocs.languageBloc.add(
      //     ChangeLanguage(
      //       selectedVal: 1,
      //       locale: Locale("ar"),
      //     ),
      //   );
      // }

      //Setup user if Exist ......
      if (PreferencesUtils.containsKey(Preferences.user)) {
        String userData = PreferencesUtils.getString(Preferences.user);

        if (userData != null) {
          // Application.user = User.fromJson(jsonDecode(userData));


           print("Decoded from Shared Saving ...."  + jsonDecode(userData).toString());
        }
      }

      AppBlocs.authenticationBloc.add(OnAuthInit());


      //Do NetWork Requist Here ...
      // await Future.delayed(Duration(milliseconds: 2000));
      try {
        
        // if(Application.user != null){
        //   AppBlocs.firebasemessagingtokenBloc.add(GetAndSendUserToken(Application.user.id.toString()));
        // }
        
        yield AppSetupInComplete();

      }  catch (e) {
        print('Cities Error ... $e');
        yield AppSetupInFailer(e.toString());
      }

      // yield AppSetupInComplete();
    }
  }
}
