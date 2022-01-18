import 'package:ocean_fruits/src/core/config/dio_config.dart';
import 'package:ocean_fruits/src/modules/main-view/models/main_route_response.dart';

class MainRouteRepository {
  Future<MainRouteResponse> fetchMainRoute() async {
    final respose = await DioManager.dio.get("url");
  }
}
