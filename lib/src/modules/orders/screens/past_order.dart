import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_alert_not_autherazed.dart';
import '../provider/orders_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../main-view/screens/tap_screen.dart';
import '../../../core/utils/app_constant.dart';
import '../widgets/order_item.dart';

class PastOrder extends StatefulWidget {
  const PastOrder({Key key}) : super(key: key);

  @override
  _PastOrderState createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder>
    with AutomaticKeepAliveClientMixin {
  var _subscription;
  Connectivity _connectivity;
  bool _keepAlive = false;

  Future<void> _showArrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate("noConnection", context)),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _subscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          setState(() {});
        }
        if (result == ConnectivityResult.none) {
          return _showArrorDialog(translate("checkInternet", context));
        }
      },
      // onError: (e) =>
    );
    _doAsyncStuff();
  }

  @override
  dispose() {
    super.dispose();
    _subscription.cancel();
  }

  Future<void> _doAsyncStuff() async {
    _keepAlive = true;
    updateKeepAlive();
    // Keeping alive...

    await Future.delayed(const Duration(minutes: 10));

    _keepAlive = false;
    updateKeepAlive();
    // Can be disposed whenever now.
  }

  @override
  bool get wantKeepAlive => _keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
          return Center(
            child: sleekCircularSlider(
                context, 40, AppColors.scondryColor, AppColors.greenColor),
          );
        } else {
          if (snapShote.error != null) {
            if (snapShote.error.toString() == "8") {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(TapScreen.routeName);
                      },
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
              );
            }
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: screenUtil.setHeight(500),
                  width: screenUtil.setWidth(700),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      boxShadow(),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      translate("anErrorOccurred", context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: screenUtil.setSp(35),
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
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  TapScreen.routeName);
                            },
                            child: SizedBox(
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

  BoxShadow boxShadow() {
    return const BoxShadow(
      blurRadius: 10,
      offset: Offset(10, 10),
      color: Colors.grey,
    );
  }
}
