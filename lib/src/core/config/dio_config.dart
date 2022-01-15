import 'package:dio/dio.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';

var options = BaseOptions(
  baseUrl: Application.domain,
  headers: {
    'content-type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer ' + Application.user.accessToken,
  },
  connectTimeout: 20000,
  receiveTimeout: 20000,
);

class DioManager {
  static final Dio dio = Dio(options);

  ///Singleton factory
  static final DioManager _instance = DioManager._internal();

  factory DioManager() {
    // We can Intialize Dio and DioOprtion here ...........
    return _instance;
  }

  DioManager._internal();
}


//  DioManager.dio.options.headers['Authorization'] = 'Bearer ' + "${Application.user == null ? "" : Application.user.accessToken}" ;