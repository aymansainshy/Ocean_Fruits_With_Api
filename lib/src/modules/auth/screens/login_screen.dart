import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';

import 'sign_up_screen.dart';
import '../../lang/provider/language_provider.dart';
import '../widgets/login_form.dart';
import '../../../core/utils/app_constant.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  final bool isSingUp;

  const LoginScreen({
    Key key,
    this.isSingUp = false,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    ScreenUtil screenUtil = ScreenUtil();

    final langugeProvider = Provider.of<LanguageProvider>(context);
    String appLang =
        langugeProvider.appLocal.languageCode == "ar" ? "العربية" : "English";
    return Scaffold(
      // backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 25),
              child: Hero(
                tag: 'logoAnimation',
                child: Image.asset(
                  AssetsUtils.oceanFruitsLogo,
                  fit: BoxFit.contain,
                  color: AppColors.scondryColor,
                  height: isLandScape
                      ? screenUtil.setHeight(600)
                      : screenUtil.setHeight(480),
                  width: isLandScape
                      ? screenUtil.setHeight(700)
                      : screenUtil.setHeight(580),
                ),
              ),
            ),
            SizedBox(
              height: screenUtil.setHeight(150),
            ),
            LoginForm(widget.isSingUp, isLandScape, screenUtil),
            SizedBox(
              height: screenUtil.setHeight(150),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translate("youDontHaveAccount", context),
                  style: TextStyle(
                    fontSize: isLandScape
                        ? screenUtil.setSp(25)
                        : screenUtil.setSp(40),
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 3),
                InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUpScreen.routeName);
                  },
                  child: Text(
                    translate("createNewAccount", context),
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
            SizedBox(
              height: screenUtil.setHeight(100),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton(
                // dropdownColor: AppColors.primaryColor,
                items: langugeProvider.languages
                    .map(
                      (lang) => DropdownMenuItem(
                        value: lang.localName,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              lang.localName,
                              style: TextStyle(
                                fontSize: isLandScape
                                    ? screenUtil.setSp(20)
                                    : screenUtil.setSp(35),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: isLandScape
                                  ? screenUtil.setHeight(55)
                                  : screenUtil.setHeight(40),
                              width: isLandScape
                                  ? screenUtil.setWidth(55)
                                  : screenUtil.setWidth(40),
                              child: Image.asset(
                                lang.flag,
                                fit: BoxFit.contain,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          langugeProvider.changeLanguage(Locale(lang.code));
                        },
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    appLang = value;
                  });
                },
                value: appLang,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
