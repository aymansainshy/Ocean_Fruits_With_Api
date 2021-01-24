import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../utils/custom_page_transition.dart';
import '../lang/app_locelazation.dart';

class AppColors {
  static const Color circleColor = Color.fromRGBO(195, 246, 164, 1);
  static const Color scondryColor = Color.fromRGBO(98, 171, 53, 1);
  static const Color primaryColor = Color.fromRGBO(70, 70, 70, 1);
  static const Color greenColor = Color.fromRGBO(0, 178, 36, 1);
  static const Color redColor = Color.fromRGBO(255, 0, 0, 1);
}

ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primaryColor,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  // fontFamily: 'Cairo',
  pageTransitionsTheme: PageTransitionsTheme(builders: {
    TargetPlatform.android: CustomPageTransitionBuilder(),
    TargetPlatform.iOS: CustomPageTransitionBuilder(),
  }),
  //.copyWith(
  //  pageTransitionsTheme: const PageTransitionsTheme(
  //    builders: <TargetPlatform, PageTransitionsBuilder>{
  //      TargetPlatform.android: ZoomPageTransitionsBuilder(),
  //      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
  //    },
  //  ),
);

String translate(String text, BuildContext context) {
  return AppLocalizations.of(context).translate(text);
}

Widget sleekCircularSlider(
    BuildContext context, double size, Color color1, Color color2) {
  return SleekCircularSlider(
    initialValue: 20,
    max: 100,
    onChange: (v) {},
    appearance: CircularSliderAppearance(
      spinnerMode: true,
      infoProperties: InfoProperties(),
      angleRange: 360,
      startAngle: 90,
      size: size,
      customColors: CustomSliderColors(
        hideShadow: true,
        dotColor: Colors.transparent,
        progressBarColors: [color1, color2],
        trackColor: Colors.transparent,
      ),
      customWidths: CustomSliderWidths(
        progressBarWidth: 4.0,
        trackWidth: 3.0,
      ),
    ),
  );
}
