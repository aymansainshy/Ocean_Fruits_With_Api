import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/sign_up_screen.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';

class CustomAlertNotAutherazed extends StatefulWidget {
  final Color color;
  final IconData iconData;
  final String topText;
  final String bottomText;

  const CustomAlertNotAutherazed({
    Key key,
    @required this.color,
    @required this.iconData,
    @required this.topText,
    @required this.bottomText,
  }) : super(key: key);
  @override
  _CustomAlertNotAutherazedState createState() =>
      _CustomAlertNotAutherazedState();
}

class _CustomAlertNotAutherazedState extends State<CustomAlertNotAutherazed> {
  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LanguageProvider>(context).appLocal;
    final mediaQuery = MediaQuery.of(context).size;

    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: [
            Container(
              height: isLandScape
                  ? screenUtil.setHeight(1000)
                  : screenUtil.setHeight(700),
              width: isLandScape
                  ? screenUtil.setWidth(600)
                  : screenUtil.setWidth(800),
              padding: isLandScape
                  ? mediaQuery.height < 400
                      ? EdgeInsets.only(top: 15, left: 30, right: 30)
                      : EdgeInsets.only(top: 35, left: 30, right: 30)
                  : mediaQuery.height < 600
                      ? EdgeInsets.only(top: 40, left: 30, right: 30)
                      : EdgeInsets.only(top: 55, left: 30, right: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  FittedBox(
                    child: Text(
                      widget.topText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: locale.languageCode == 'ar'
                            ? isLandScape
                                ? mediaQuery.height < 400
                                    ? screenUtil.setSp(20)
                                    : screenUtil.setSp(25)
                                : screenUtil.setSp(40)
                            : isLandScape
                                ? mediaQuery.height < 400
                                    ? screenUtil.setSp(20)
                                    : screenUtil.setSp(30)
                                : screenUtil.setSp(45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.bottomText,
                    style: TextStyle(
                      fontSize: isLandScape
                          ? screenUtil.setSp(20)
                          : screenUtil.setSp(35),
                    ),
                  ),
                  Container(
                    width: screenUtil.setWidth(500),
                    height: isLandScape
                        ? mediaQuery.height < 400
                            ? screenUtil.setHeight(110)
                            : screenUtil.setHeight(170)
                        : screenUtil.setHeight(120),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(SignUpScreen.routeName);
                      },
                      textColor: Colors.white,
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        translate("signUp", context),
                        style: TextStyle(
                          fontSize: locale.languageCode == 'ar'
                              ? isLandScape
                                  ? screenUtil.setSp(15)
                                  : screenUtil.setSp(35)
                              : isLandScape
                                  ? screenUtil.setSp(20)
                                  : screenUtil.setSp(40),
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 10),
                    child: Text(
                      translate("or", context),
                      style: TextStyle(
                        fontSize: isLandScape
                            ? mediaQuery.height < 400
                                ? screenUtil.setSp(15)
                                : screenUtil.setSp(25)
                            : screenUtil.setSp(45),
                      ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      translate("login", context),
                      style: TextStyle(
                        fontSize: locale.languageCode == 'ar'
                            ? isLandScape
                                ? mediaQuery.height < 400
                                    ? screenUtil.setSp(12)
                                    : screenUtil.setSp(15)
                                : screenUtil.setSp(35)
                            : isLandScape
                                ? mediaQuery.height < 600
                                    ? screenUtil.setSp(20)
                                    : screenUtil.setSp(25)
                                : screenUtil.setSp(45),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: mediaQuery.height < 600 ? -20 : -45,
              child: CircleAvatar(
                radius: isLandScape
                    ? mediaQuery.height < 700
                        ? screenUtil.setSp(40)
                        : screenUtil.setSp(60)
                    : screenUtil.setSp(100),
                backgroundColor: widget.color,
                child: Icon(
                  widget.iconData,
                  color: Colors.white,
                  size: isLandScape
                      ? screenUtil.setSp(70)
                      : screenUtil.setSp(100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
