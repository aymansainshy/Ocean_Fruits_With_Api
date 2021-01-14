import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_alert_not_autherazed.dart';
import '../providers/orders_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/tap_screen.dart';
import '../utils/app_constant.dart';
import '../widgets/order_item.dart';

class PastOrder extends StatefulWidget {
  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  // var _subscription;
  // Connectivity _connectivity;

  // void _showArrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text(translate("noConnection", context)),
  //       content: Text(message),
  //       actions: [
  //         FlatButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text("Ok"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   _connectivity = Connectivity();
  //   _subscription =
  //       _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
  //     if (result == ConnectivityResult.mobile ||
  //         result == ConnectivityResult.wifi) {
  //       setState(() {});
  //     }

  //     //  else {
  //     //   _showArrorDialog(translate("checkInternet", context));
  //     // }
  //   });
  //   super.initState();
  // }

  // @override
  // dispose() {
  //   super.dispose();
  //   _subscription.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final userData = Provider.of<AuthProvider>(context, listen: false);

    if (!userData.isAuth) {
      return CustomAlertNotAutherazed(
        color: Colors.yellow[800],
        topText: translate("youDontHavOrder2", context),
        bottomText: translate("please", context),
        iconData: Icons.priority_high,
      );
    }

    return FutureBuilder(
      future: Provider.of<Orders>(context, listen: false)
          .fetchOrder(userData.userId),
      builder: (context, snapShote) {
        if (snapShote.connectionState == ConnectionState.waiting) {
          return Container(
              width: double.infinity,
              height: isLandScape
                  ? screenUtil.setHeight(660)
                  : screenUtil.setHeight(330),
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.greenColor,
                  strokeWidth: 2.5,
                ),
              ));
        } else {
          if (snapShote.error != null) {
            if (snapShote.error.toString() == "8") {
              return Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed(TapScreen.routeName);
                        },
                        child: Container(
                          child: Image.asset(
                            "assets/icons/cart_empty.png",
                            height: isLandScape
                                ? screenUtil.setHeight(600)
                                : screenUtil.setHeight(600),
                            width: isLandScape
                                ? screenUtil.setWidth(300)
                                : screenUtil.setWidth(400),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenUtil.setHeight(100),
                      ),
                      Text(
                        translate("youDontHavOrder2", context),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: isLandScape
                              ? screenUtil.setSp(35)
                              : screenUtil.setSp(45),
                          fontWeight: FontWeight.bold,
                          wordSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: screenUtil.setHeight(500),
                  width: screenUtil.setWidth(700),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      translate("anErrorOccurred", context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLandScape
                            ? screenUtil.setSp(35)
                            : screenUtil.setSp(40),
                        fontWeight: FontWeight.bold,
                        wordSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Consumer<Orders>(
              builder: (context, order, _) {
                final orders = order.pastOrder().reversed.toList();
                return orders.isEmpty
                    ? Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      TapScreen.routeName);
                                },
                                child: Container(
                                  height: screenUtil.setHeight(700),
                                  width: screenUtil.setWidth(700),
                                  // color: Colors.red,
                                  child: Image.asset(
                                    "assets/icons/cart_empty.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: screenUtil.setHeight(100),
                              ),
                              Text(
                                translate("youDontHavOrder2", context),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(35)
                                      : screenUtil.setSp(45),
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, i) => OrderItem(
                          order: orders[i],
                          isLandScape: isLandScape,
                          screenUtil: screenUtil,
                          expanded: false,
                        ),
                      );
              },
            );
          }
        }
      },
    );
  }
}
