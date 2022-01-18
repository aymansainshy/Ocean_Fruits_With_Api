import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/modules/user-profile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static bool debug = true;
  static User user;
  static String version = '1.0.0';
  static String domain = "https://veget.ocean-sudan.com";
  static SharedPreferences preferences;
  static ScreenUtil screenUtil = ScreenUtil();

  /// Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
