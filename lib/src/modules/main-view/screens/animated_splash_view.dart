import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/core/config/app_config.dart';
import 'package:ocean_fruits/src/core/utils/app_constant.dart';

// Widget _home;
int _duration;
String _imagePath;
// AnimatedSplashType _animatedType;

enum AnimatedSplashType { StaticDuration, BackgroundProcess }

class AnimatedSplashView extends StatefulWidget {
  AnimatedSplashView({Key key, 
    @required int duration,
    AnimatedSplashType type,
    Widget home,
    @required String imagePath,
  }) : super(key: key) {
    assert(duration != null);
    // assert(home != null);
    assert(imagePath != null);

    // _home = home;
    _duration = duration;
    _imagePath = imagePath;
    // _animatedType = type;
  }

  @override
  _AnimatedSplashState createState() => _AnimatedSplashState();
}

class _AnimatedSplashState extends State<AnimatedSplashView>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    if (_duration < 1000) _duration = 2000;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc));
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  String error;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // var mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: SizedBox(
            height: isLandScape
                ? Application.screenUtil.setHeight(2000)
                : Application.screenUtil.setHeight(600),
            width: isLandScape
                ? Application.screenUtil.setWidth(700)
                : Application.screenUtil.setWidth(800),
            child: Image.asset(
              _imagePath,
              fit: isLandScape ? BoxFit.fill : BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
