import 'package:flutter/material.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'edit_profile_screen.dart';
import '../../../core/widgets/custom_alert_not_autherazed.dart';
import '../../auth/provider/auth_provider.dart';
import '../../lang/provider/language_provider.dart';
import '../../../core/utils/app_constant.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "profile-name";

  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    var mediaQuery = MediaQuery.of(context).size;

    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();

    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // final userData = Provider.of<AuthProvider>(context, listen: false);
    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(),
        child: SizedBox(
          height: isLandScape
              ? screenUtil.setHeight(150)
              : screenUtil.setHeight(100),
          width: screenUtil.setWidth(100),
          // color: Colors.green,
          child: language == "ar"
              ? Image.asset(
                  AssetsUtils.arrowBackIcon2,
                  fit: BoxFit.contain,
                  // color: Colors.white,
                )
              : Image.asset(
                  AssetsUtils.arrowBackIcon,
                  fit: BoxFit.contain,
                  // color: Colors.white,
                ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Consumer<AuthProvider>(builder: (context, userData, _) {
        if (!userData.isAuth) {
          return CustomAlertNotAutherazed(
            color: Colors.yellow[800],
            topText: translate("noProfile", context),
            bottomText: translate("please", context),
            iconData: Icons.priority_high,
          );
        } else {
          return Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: [
              Container(
                height: isLandScape
                    ? screenUtil.setHeight(900)
                    : screenUtil.setHeight(800),
                width: double.infinity,
                color: Colors.white,
                child: Image.asset(
                  AssetsUtils.greenPaperImage,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Container(
                  height: mediaQuery.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          userData.userName ?? "",
                          style: TextStyle(
                            fontSize: isLandScape
                                ? screenUtil.setSp(40)
                                : screenUtil.setSp(70),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          userData.userEmail ?? "",
                          style: TextStyle(
                            fontSize: isLandScape
                                ? screenUtil.setSp(30)
                                : screenUtil.setSp(40),
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: screenUtil.setHeight(30),
                        ),
                        SizedBox(
                          width: isLandScape
                              ? screenUtil.setWidth(300)
                              : screenUtil.setWidth(400),
                          height: isLandScape
                              ? screenUtil.setHeight(170)
                              : screenUtil.setHeight(90),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: AppColors.primaryColor,
                            textColor: Colors.white,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Transform.translate(
                                      offset: const Offset(-5, 0),
                                      child: FittedBox(
                                        child: Text(
                                          translate("editProfile", context),
                                          style: TextStyle(
                                            fontSize: isLandScape
                                                ? screenUtil.setSp(20)
                                                : screenUtil.setSp(35),
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      // color: Colors.redAccent,
                                      height: isLandScape
                                          ? screenUtil.setHeight(90)
                                          : screenUtil.setHeight(70),
                                      width: screenUtil.setWidth(70),
                                      child: Image.asset(
                                        AssetsUtils.editIcon,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(EditProfileScreen.routeName);
                            },
                          ),
                        ),
                        SizedBox(
                          height: screenUtil.setHeight(50),
                        ),
                        Card(
                          child: SizedBox(
                            width: screenUtil.setWidth(900),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenUtil.setHeight(30),
                                ),
                                BuildProfileCardText(
                                  isLandScape: isLandScape,
                                  screenUtil: screenUtil,
                                  text1: translate("userName", context),
                                  text2: userData.userName ?? "",
                                ),
                                BuildProfileCardText(
                                  isLandScape: isLandScape,
                                  screenUtil: screenUtil,
                                  text1: translate("email", context),
                                  text2: userData.userEmail ?? "",
                                ),
                                BuildProfileCardText(
                                  isLandScape: isLandScape,
                                  screenUtil: screenUtil,
                                  text1: translate("address", context),
                                  text2: userData.userAddress ?? '',
                                ),
                                BuildProfileCardText(
                                  isLandScape: isLandScape,
                                  screenUtil: screenUtil,
                                  text1: translate("phone", context),
                                  text2: userData.userPhone ?? '',
                                ),
                                // BuildProfileCardText(
                                //   isLandScape: isLandScape,
                                //   screenUtil: screenUtil,
                                //   text1: translate("password", context),
                                //   text2: "We well not upear the password here",
                                //   isDivider: false,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

// ignore: must_be_immutable
class BuildProfileCardText extends StatelessWidget {
  BuildProfileCardText({
    Key key,
    this.isDivider = true,
    @required this.isLandScape,
    @required this.screenUtil,
    @required this.text1,
    @required this.text2,
  }) : super(key: key);

  bool isDivider;
  final bool isLandScape;
  final ScreenUtil screenUtil;
  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: TextStyle(
              fontSize:
                  isLandScape ? screenUtil.setSp(20) : screenUtil.setSp(35),
              color: Colors.grey,

              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            text2,
            style: TextStyle(
              fontSize:
                  isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(40),
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          if (isDivider)
            Divider(
              color: Colors.grey.shade300,
              height: 1,
              thickness: 2.0,
            ),
        ],
      ),
    );
  }
}
