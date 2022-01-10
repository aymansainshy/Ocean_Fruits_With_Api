import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(
    // this.userRepository
  ) : super(RegisterInitial());

  // final UserRepository userRepository;

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterMe) {
      try {

        yield RegisterInProgress();
        // final userData = await userRepository.logInAndRegeister(DataPoster(url: Urls.registerUrl(), data: event.registerData));
        // yield RegisterInSuccess(userData.id.toString());

      } on DioError catch (e) {
        yield RegisterInFailer(errorMassage: e.response.data['code'].toString());
        
      } catch (e) {
        print("register error .. $e");
        yield RegisterInFailer(errorMassage: e.toString());
      }
    }
  }
}
