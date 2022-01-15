import 'package:flutter/material.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'build_drawer_list.dart';
import '../../modules/auth/provider/auth_provider.dart';
import '../../modules/lang/screens/language_screen.dart';
import '../../modules/user-profile/screens/profile_screen.dart';
import '../../modules/orders/screens/order_screen.dart';
// import '../screens/tap_screen.dart';
import '../utils/app_constant.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();

    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final authData = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              height: isLandScape
                  ? screenUtil.setHeight(700)
                  : screenUtil.setHeight(500),
              color: AppColors.primaryColor,
              child: Image.asset(
                AssetsUtils.oceanFruitsLogo,
                fit: BoxFit.contain,
              ),
            ),
            // SizedBox(height: 5),
            // Divider(
            //   height: 6,
            //   thickness: 1,
            //   color: Colors.grey,
            // ),
            // BuildDrawerList(
            //   leading: Image.asset(
            //     'assets/icons/home stroke.png',
            //     color: Colors.white,
            //     height: screenUtil.setHeight(65),
            //     width: screenUtil.setWidth(65),
            //   ),
            //   title: translate("home", context),
            //   onTap: () {
            //     Navigator.of(context).pushReplacementNamed(TapScreen.routeName);
            //   },
            // ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              title: translate("profile", context),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ProfileScreen.routeName);
              },
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: const Icon(
                Icons.shop,
                color: Colors.white,
              ),
              title: translate("order", context),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(OrderScreen.routeName);
              },
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              title: translate("language", context),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(LanguageScreen.routeName);
              },
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: const Icon(
                Icons.phone,
                color: Colors.white,
              ),
              title: translate("contactUs", context),
              onTap: () =>
                  showContactUsDailog(isLandScape, screenUtil, context),
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: translate("aboutUs", context),
              onTap: () => showAboutDailog(isLandScape, screenUtil, context),
            ),
            const Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            if (authData.isAuth)
              BuildDrawerList(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: translate("logOut", context),
                onTap: () async {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(translate("areYouSure", context)),
                      content: Text(translate("youWantLogOut", context)),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            translate("yes", context),
                            style: const TextStyle(
                              color: AppColors.redColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            translate("no", context),
                            style: const TextStyle(
                              color: AppColors.greenColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  ).then((isOk) {
                    if (isOk) {
                      authData.logOut();
                      Navigator.of(context).pushReplacementNamed('/');
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            if (!authData.isAuth)
              BuildDrawerList(
                leading: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: translate("login", context),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrls(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Can't launch");
  }
}

Future<void> _launchPhone(String phone) async {
  var url = "tel:${phone.toString()}";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Can't launch");
  }
}

Future<void> _launchMail(String mail) async {
  var url = "mailto:${mail.toString()}?subject=hello";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print("Can't launch");
  }
}

Future<void> showAboutDailog(
    bool isLandScape, ScreenUtil screenUtil, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.primaryColor,
      scrollable: true,
      elevation: 0.0,
      title: Column(
        children: [
          Image.asset(
            'assets/images/Ocean Agriculture fruit & Vegetables-01.png',
            height: isLandScape
                ? screenUtil.setHeight(200)
                : screenUtil.setHeight(300),
            width: isLandScape
                ? screenUtil.setWidth(200)
                : screenUtil.setWidth(300),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Text(
              "Ocean Fruits & Vegetable ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
                color: AppColors.scondryColor,
                fontFamily: "Cairo",
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        height:
            isLandScape ? screenUtil.setHeight(800) : screenUtil.setHeight(600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 220,
              child: Text(
                translate("oceanAboutUs", context),
                style: TextStyle(
                  fontSize:
                      isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
                  color: Colors.white60,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translate("poweredBy", context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isLandScape
                        ? screenUtil.setSp(18)
                        : screenUtil.setSp(30),
                    color: AppColors.greenColor,
                  ),
                ),
                const SizedBox(width: 5),
                InkWell(
                  onTap: () => _launchUrls('https://ease-group.com/'),
                  child: Text(
                    'Ease-group',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: isLandScape
                          ? screenUtil.setSp(15)
                          : screenUtil.setSp(30),
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> showContactUsDailog(
    bool isLandScape, ScreenUtil screenUtil, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.primaryColor,
      scrollable: true,
      elevation: 0.0,
      title: Column(
        children: [
          Image.asset(
            AssetsUtils.oceanFruitsLogo,
            height: isLandScape
                ? screenUtil.setHeight(200)
                : screenUtil.setHeight(300),
            width: isLandScape
                ? screenUtil.setWidth(200)
                : screenUtil.setWidth(300),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Text(
              "Ocean Fruits & Vegetable ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
                color: AppColors.scondryColor,
                fontFamily: "Cairo",
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        height:
            isLandScape ? screenUtil.setHeight(800) : screenUtil.setHeight(600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => _launchUrls(
                      "https://www.linkedin.com/in/ayman-abdulrahman-4aa89b195/"),
                  child: SizedBox(
                    height: screenUtil.setHeight(200),
                    width: screenUtil.setWidth(200),
                    child: Image.asset(
                      AssetsUtils.facebookIcon,
                      fit: BoxFit.contain,
                      color: Colors.blue,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _launchPhone("+249911098045"),
                  child: SizedBox(
                    height: screenUtil.setHeight(200),
                    width: screenUtil.setWidth(200),
                    child: Image.asset(
                      AssetsUtils.phoneCallIcon,
                      fit: BoxFit.contain,
                      color: AppColors.greenColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => _launchMail("aymansainshy@gmail.com"),
                  child: SizedBox(
                    height: screenUtil.setHeight(200),
                    width: screenUtil.setWidth(200),
                    child: Image.asset(
                      AssetsUtils.emailIcon,
                      fit: BoxFit.contain,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _launchUrls("https://twitter.com/aymansainshy1"),
                  child: SizedBox(
                    height: screenUtil.setHeight(200),
                    width: screenUtil.setWidth(200),
                    child: Image.asset(
                      AssetsUtils.twitterIcon,
                      fit: BoxFit.contain,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
