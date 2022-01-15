import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/modules/auth/bloc/isAuth-bloc/auth_bloc.dart';
import 'src/modules/main-view/bloc/app-start-bloc/app_bloc.dart';

class AppBlocs {
  static final appBloc = AppBloc();
  // static final otpBloc = OtpBloc(userRepository);
  static final authenticationBloc = AuthenticationBloc();

  static final List<BlocProvider> providers = [
    BlocProvider<AppBloc>(
      create: (context) => appBloc,
    ),
    BlocProvider<AuthenticationBloc>(
      create: (context) => authenticationBloc,
    ),
  ];

  static void dispose() {
    appBloc.close();
    authenticationBloc.close();
  }

  ///Singleton factory
  static final AppBlocs _instance = AppBlocs._internal();

  factory AppBlocs() {
    return _instance;
  }

  AppBlocs._internal();
}
