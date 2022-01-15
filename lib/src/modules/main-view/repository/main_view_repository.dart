import 'package:ocean_fruits/src/core/config/dio_config.dart';

class MainViewRepository {
  Future<dynamic> fetchMainRoute() async {
    final respose = await DioManager.dio.get("url");
  }
}
