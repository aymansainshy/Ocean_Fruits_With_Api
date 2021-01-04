import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../lang/language_provider.dart';
import '../widgets/upcoming_order.dart';
import '../widgets/past_order.dart';
import '../utils/app_constant.dart';
import '../widgets/drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = 'order_screen';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final List<Widget> _tabBarView = [
      PastOrder(),
      UpComingOrder(),
    ];

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          // toolbarHeight: 68,
          textTheme: Theme.of(context).textTheme,
          actionsIconTheme: Theme.of(context).accentIconTheme,
          iconTheme: Theme.of(context).iconTheme,
          // backgroundColor: Color.fromARGB(0, 0, 0, 1),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          elevation: 0.0,
          leading: Builder(
            builder: (context) => Transform.translate(
              offset: Offset(6, 0),
              child: IconButton(
                padding: const EdgeInsets.all(0.0),
                onPressed: () => Navigator.of(context).pop(),
                icon: Container(
                  // color: Colors.teal,
                  height: 30,
                  width: 50,
                  child: language == "ar"
                      ? Image.asset(
                          "assets/icons/arrow_back2.png",
                          fit: BoxFit.contain,
                          color: Colors.white,
                        )
                      : Image.asset(
                          "assets/icons/arrow_back.png",
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ),
          title: Text(
            translate("order", context),
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.scondryColor,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize:
                  isLandScape ? screenUtil.setSp(25) : screenUtil.setSp(40),
            ),
            tabs: [
              Tab(text: translate("past", context)),
              Tab(text: translate("upComing", context)),
            ],
          ),
        ),
        body: TabBarView(
          children: _tabBarView,
        ),
      ),
    );
  }
}
