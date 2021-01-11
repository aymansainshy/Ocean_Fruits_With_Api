import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../providers/products_provider.dart';
import '../widgets/shared_product_item.dart';
import '../providers/auth_provider.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = 'favorites_screen';
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  const FavoritesScreen({
    Key key,
    this.tapScaffoldKey,
  }) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();

    var _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final userData = Provider.of<AuthProvider>(context, listen: false);

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.primaryColor,
        // backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0.0,
        leading: Builder(
          builder: (context) => Transform.translate(
            offset: Offset(6, 0),
            child: IconButton(
              padding: language == "ar"
                  ? EdgeInsets.only(right: 15)
                  : EdgeInsets.all(0.0),
              onPressed: () => widget.tapScaffoldKey.currentState.openDrawer(),
              icon: Container(
                // color: Colors.teal,
                height: 30,
                width: 50,
                child: language == "ar"
                    ? Image.asset(
                        "assets/icons/Menu icon2.png",
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/icons/Menu icon.png",
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ),
        title: Text(
          translate("favorits", context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: !userData.isAuth
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenUtil.setHeight(700),
                    width: screenUtil.setWidth(700),
                    // color: Colors.red,
                    child: Image.asset(
                      "assets/icons/fav_empty.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: screenUtil.setSp(40),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    child: Text(
                      translate("youDontHaveFav", context),
                      style: TextStyle(
                        fontSize: _isLandScape
                            ? screenUtil.setSp(20)
                            : screenUtil.setSp(40),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder(
              future: Provider.of<Products>(context, listen: false)
                  .fetchFavoritesProducts(userData.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: AppColors.greenColor,
                      strokeWidth: 2.5,
                    ),
                  );
                } else {
                  if (snapshot.error != null) {
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
                                fontSize: screenUtil.setSp(45),
                                fontWeight: FontWeight.bold,
                                wordSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Consumer<Products>(
                      builder: (context, product, _) {
                        return product.favProduct.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: screenUtil.setHeight(700),
                                      width: screenUtil.setWidth(700),
                                      // color: Colors.red,
                                      child: Image.asset(
                                        "assets/icons/fav_empty.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenUtil.setSp(40),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.5,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        translate("youDontHaveFav", context),
                                        style: TextStyle(
                                          fontSize: _isLandScape
                                              ? screenUtil.setSp(20)
                                              : screenUtil.setSp(40),
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _isLandScape ? 5 : 15),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: _isLandScape ? 1 : 5,
                                    mainAxisSpacing: _isLandScape ? 1 : 5,
                                  ),
                                  itemCount: products.favProduct.length,
                                  itemBuilder: (context, index) =>
                                      ChangeNotifierProvider.value(
                                    value: products.favProduct[index],
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: SharedProductItem(),
                                    ),
                                  ),
                                ),
                              );
                      },
                    );
                  }
                }
              },
            ),
    );
  }
}
