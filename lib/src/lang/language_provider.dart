import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/language_model.dart';

class LanguageProvider with ChangeNotifier {
  // static const API = '';
  // static const header = {'Content-Type': 'application/json'};

  /// Fetch LOCAL AND CHANGE LANGUAGE
  /// [START]
  Locale _appLocale = Locale("en");
  Locale get appLocal => _appLocale ?? Locale("ar");

  Future<void> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return;
    }
    _appLocale = Locale(prefs.getString('language_code'));
  }

  Future<void> changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', 'SA');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }

  List<Language> get languages => _languages;
  List<Language> _languages = [
    Language(
      "en",
      "English",
      "English",
      "assets/images/united-states-of-america.png",
      selected: true,
    ),
    Language(
      "ar",
      "Arabic",
      "العربية",
      "assets/images/united-arab-emirates.png",
    ),
  ];

  String unitTile(String unit) {
    switch (unit) {
      case "0":
        return _appLocale.languageCode == "ar" ? "كيلو" : "Kg";
        break;
      case "1":
        return _appLocale.languageCode == "ar" ? "حبة" : "Haba";
        break;
      case "2":
        return _appLocale.languageCode == "ar" ? "ربطة" : "Rapta";
        break;
      case "3":
        return _appLocale.languageCode == "ar" ? "دستة" : "Dasta";
        break;
      case "4":
        return _appLocale.languageCode == "ar" ? "رزمة" : "Rasma";
        break;
      default:
        return _appLocale.languageCode == "ar" ? "كيلو" : "Kg";
    }
  }
}
