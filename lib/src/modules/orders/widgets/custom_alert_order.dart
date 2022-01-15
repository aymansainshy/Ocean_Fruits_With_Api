import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_constant.dart';

class CustomAlertOrder extends StatefulWidget {
  final Color color;
  final IconData iconData;
  final String topText;
  final String bottomText;
  final Function function;

  const CustomAlertOrder({
    Key key,
    @required this.color,
    @required this.iconData,
    @required this.topText,
    @required this.bottomText,
    @required this.function,
  }) : super(key: key);
  @override
  _CustomAlertOrderState createState() => _CustomAlertOrderState();
}

class _CustomAlertOrderState extends State<CustomAlertOrder> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          overflow: Overflow.visible,
          children: [
            Container(
              height: isLandScape
                  ? screenUtil.setHeight(1000)
                  : screenUtil.setHeight(660),
              width: isLandScape
                  ? screenUtil.setWidth(600)
                  : screenUtil.setWidth(800),
              padding: const EdgeInsets.only(top: 55, left: 30, right: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                  // topLeft: Radius.circular(30),
                  // topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: isLandScape ? 5 : 15),
                  FittedBox(
                    child: Text(
                      widget.topText,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: isLandScape
                            ? screenUtil.setSp(30)
                            : screenUtil.setSp(45),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.bottomText,
                    style: TextStyle(
                      fontSize: isLandScape
                          ? screenUtil.setSp(25)
                          : screenUtil.setSp(40),
                    ),
                  ),
                  SizedBox(height: mediaQuery.height > 550 ? 30 : 10),
                  SizedBox(
                    width: screenUtil.setWidth(500),
                    height: isLandScape
                        ? screenUtil.setHeight(170)
                        : screenUtil.setHeight(120),
                    child: RaisedButton(
                      onPressed: widget.function,
                      textColor: Colors.white,
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: isLandScape
                              ? screenUtil.setSp(25)
                              : screenUtil.setSp(45),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -45,
              child: CircleAvatar(
                radius:
                    isLandScape ? screenUtil.setSp(70) : screenUtil.setSp(110),
                backgroundColor: widget.color,
                child: Icon(
                  widget.iconData,
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
