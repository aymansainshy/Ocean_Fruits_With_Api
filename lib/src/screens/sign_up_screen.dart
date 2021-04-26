import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/login_screen.dart';
import '../lang/language_provider.dart';
import '../widgets/sign_up_form.dart';
import '../utils/app_constant.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/sign-up-screen';
  final bool isLogin;

  const SignUpScreen({
    Key key,
    this.isLogin = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    ScreenUtil screenUtil = ScreenUtil();

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: isLandScape ? null : () => Navigator.of(context).pop(),
        child: Container(
          height: isLandScape
              ? screenUtil.setHeight(140)
              : screenUtil.setHeight(100),
          width:
              isLandScape ? screenUtil.setWidth(140) : screenUtil.setWidth(100),
          // color: Colors.green,
          child: language == "ar"
              ? Image.asset(
                  "assets/icons/arrow_back2.png",
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  "assets/icons/arrow_back.png",
                  fit: BoxFit.contain,
                ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // bottomNavigationBar: new BottomAppBar(
      //   color: Colors.white,
      //   child: Container(),
      // ),

      body: SingleChildScrollView(
        child: Container(
          padding:
              isLandScape ? EdgeInsets.only(top: 40) : EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  // child: Hero(
                  //   tag: 'logoAnimation',
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: Image.asset(
                  //       'assets/images/Ocean Agriculture fruit & Vegetables-01.png',
                  //       fit: BoxFit.contain,
                  //       color: AppColors.scondryColor,
                  //       height: isLandScape
                  //           ? screenUtil.setHeight(450)
                  //           : screenUtil.setHeight(470),
                  //       width: isLandScape
                  //           ? screenUtil.setHeight(600)
                  //           : screenUtil.setHeight(570),
                  //     ),
                  //   ),
                  // ),
                  ),
              SizedBox(
                height: screenUtil.setHeight(220),
              ),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 25)
                    : EdgeInsets.only(left: 25),
                child: Text(
                  translate("signUp", context),
                  style: TextStyle(
                    color: AppColors.scondryColor,
                    fontSize: isLandScape
                        ? screenUtil.setSp(30)
                        : screenUtil.setSp(60),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: screenUtil.setHeight(40),
              ),
              SignUpForm(isLogin, isLandScape, screenUtil),
              SizedBox(
                height: screenUtil.setHeight(100),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      translate("iHaveAccount", context),
                      style: TextStyle(
                        fontSize: isLandScape
                            ? screenUtil.setSp(25)
                            : screenUtil.setSp(40),
                        color: AppColors.primaryColor,
                      ),
                    ),
                    SizedBox(width: 3),
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(LoginScreen.routeName);
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => LoginScreen(
                        //       isSingUp: true,
                        //     ),
                        //   ),
                        // );
                      },
                      child: Text(
                        translate("login", context),
                        style: TextStyle(
                          color: AppColors.scondryColor,
                          fontSize: isLandScape
                              ? screenUtil.setSp(25)
                              : screenUtil.setSp(40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
