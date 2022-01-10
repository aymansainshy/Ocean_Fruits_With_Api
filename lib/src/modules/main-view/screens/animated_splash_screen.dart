import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../categories/provider/categories_manager.dart';
import '/src/core/utils/app_constant.dart';

Widget _home;
int _duration;
String _imagePath;
AnimatedSplashType _animatedType;

enum AnimatedSplashType { StaticDuration, BackgroundProcess }

class AnimatedSplashScreen extends StatefulWidget {
  AnimatedSplashScreen({
    int duration,
    AnimatedSplashType type,
    @required Widget home,
    @required String imagePath,
  }) {
    assert(duration != null);
    assert(home != null);
    assert(imagePath != null);

    _home = home;
    _duration = duration;
    _imagePath = imagePath;
    _animatedType = type;
  }

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
  }

  String error;

  @override
  Widget build(BuildContext context) {
    _animatedType == AnimatedSplashType.BackgroundProcess
        ? Future.delayed(Duration.zero).then((_) async {
            try {
              await Provider.of<CategoriesManager>(context, listen: false)
                  .fetchCategories();

              await Future.delayed(Duration(milliseconds: 500)).then((_) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => _home));
              });
            } catch (e) {
              buildShowDialog(context);

              return;
            }
          })
        : Future.delayed(Duration(milliseconds: _duration)).then((_) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) => _home));
          });

    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();

    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Container(
            height: isLandScape
                ? screenUtil.setHeight(2000)
                : screenUtil.setHeight(600),
            width: isLandScape
                ? screenUtil.setWidth(700)
                : screenUtil.setWidth(800),
            child: Image.asset(
              _imagePath,
              fit: isLandScape ? BoxFit.fill : BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {},
        behavior: HitTestBehavior.opaque,
        child: AlertDialog(
          title: Text(
            translate("anErrorOccurred", context),
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {});
              },
              child: Text(
                translate("ok", context),
                style: TextStyle(
                  color: AppColors.greenColor,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Scaffold(
//       backgroundColor: AppColors.primaryColor,
//       body: FadeTransition(
//         opacity: _animation,
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: isLandScape
//                           ? screenUtil.setHeight(400)
//                           : screenUtil.setHeight(500),
//                       width: isLandScape
//                           ? screenUtil.setWidth(700)
//                           : screenUtil.setWidth(500),
//                       child: Image.asset(
//                         _imagePath,
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Shimmer.fromColors(
//                       baseColor: AppColors.secondaryColors,
//                       highlightColor: Colors.grey.shade300,
//                       child: Text(
//                         "TOPAZ",
//                         style: TextStyle(
//                           fontSize: 60,
//                           color: AppColors.secondaryColors,
//                           letterSpacing: 2.5,
//                           // fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Transform.translate(
//                 offset: Offset(0, -30),
//                 child: Container(
//                   height: isLandScape
//                       ? screenUtil.setHeight(800)
//                       : screenUtil.setHeight(200),
//                   width: isLandScape
//                       ? screenUtil.setWidth(700)
//                       : screenUtil.setWidth(800),
//                   child: SpinKitThreeBounce(
//                     color: Colors.grey,
//                     size: 20,
//                     duration: Duration(milliseconds: 800),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
