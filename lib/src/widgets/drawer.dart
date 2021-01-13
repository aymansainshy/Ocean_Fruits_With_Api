import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/build_drawer_list.dart';
import '../providers/auth_provider.dart';
import '../screens/language_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/order_screen.dart';
// import '../screens/tap_screen.dart';
import '../utils/app_constant.dart';

class AppDrawer extends StatelessWidget {
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
              padding: EdgeInsets.all(40),
              height: isLandScape
                  ? screenUtil.setHeight(700)
                  : screenUtil.setHeight(500),
              color: AppColors.primaryColor,
              child: Image.asset(
                "assets/images/Ocean Agriculture fruit & Vegetables-01.png",
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
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: Icon(
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
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: Icon(
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
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: Icon(
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
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: Icon(
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
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            BuildDrawerList(
              leading: Icon(
                Icons.info,
                color: Colors.white,
              ),
              title: translate("aboutUs", context),
              onTap: () => showAboutDailog(isLandScape, screenUtil, context),
            ),
            Divider(
              height: 6,
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: screenUtil.setHeight(5),
            ),
            if (authData.isAuth)
              BuildDrawerList(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                title: translate("logOut", context),
                onTap: () async {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(translate("areYouSure", context)),
                      content: Text("You want logOut"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            translate("yes", context),
                            style: TextStyle(
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
                            style: TextStyle(
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
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/');
                      authData.logOut();
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                },
              ),
            if (!authData.isAuth)
              BuildDrawerList(
                leading: Icon(
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

Future<void> showAboutDailog(
    bool isLandScape, ScreenUtil screenUtil, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: isLandScape
                ? screenUtil.setHeight(400)
                : screenUtil.setHeight(300),
            width: isLandScape
                ? screenUtil.setWidth(400)
                : screenUtil.setWidth(300),
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Text(
              "Ocean Fruits & Vegetable",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        height:
            isLandScape ? screenUtil.setHeight(800) : screenUtil.setHeight(600),
        child: Expanded(
          child: Text(
            " Greate and important assets to mobile app indestory , you will have agood experience whith us  !",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:
                  isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(40),
              color: Colors.black,
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: translate("poweredBy", context),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isLandScape
                        ? screenUtil.setSp(18)
                        : screenUtil.setSp(30),
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'Ease-group',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: isLandScape
                        ? screenUtil.setSp(15)
                        : screenUtil.setSp(30),
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(),
        FlatButton(
          child: Text(
            "Ok",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:
                  isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(35),
              color: AppColors.primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

Future<void> showContactUsDailog(
    bool isLandScape, ScreenUtil screenUtil, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      scrollable: true,
      title: Column(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: isLandScape
                ? screenUtil.setHeight(400)
                : screenUtil.setHeight(300),
            width: isLandScape
                ? screenUtil.setWidth(400)
                : screenUtil.setWidth(300),
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Text(
              "Ocean Fruits & Vegetable ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize:
                    isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
      content: Container(
        height:
            isLandScape ? screenUtil.setHeight(800) : screenUtil.setHeight(600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: double.infinity,
                child: Card(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      "-  Ocean@gmail.com",
                      style: TextStyle(
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.phone,
                  size: 16,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 10),
                Text(
                  "Phone",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "-  09128842444",
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "-  09134234444",
                          style: TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
