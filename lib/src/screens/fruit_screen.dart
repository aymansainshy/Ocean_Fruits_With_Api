import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/shared_product_item.dart';
import '../providers/products_provider.dart';
import '../lang/language_provider.dart';
import '../widgets/build_cart_stack.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_screen.dart';
import '../utils/app_constant.dart';

class FruitsScreen extends StatefulWidget {
  static const routeName = 'fruits_screen';
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  const FruitsScreen({
    Key key,
    this.tapScaffoldKey,
  }) : super(key: key);

  @override
  _FruitsScreenState createState() => _FruitsScreenState();
}

class _FruitsScreenState extends State<FruitsScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final products = Provider.of<Products>(context, listen: false);

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    final cart = Provider.of<Carts>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        iconTheme: Theme.of(context).iconTheme,
        // backgroundColor: Color.fromARGB(0, 0, 0, 1),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: language == "ar"
                ? EdgeInsets.only(left: 10)
                : EdgeInsets.only(right: 10),
            child: IconButton(
              icon: BuildCartStack(carts: cart),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartScreen(isTap: true),
                ));
              },
            ),
          ),
        ],
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
          translate("fruits", context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: products.fruitesProducts.isEmpty
          ? Center(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                height: screenUtil.setHeight(500),
                width: screenUtil.setWidth(700),
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    translate('sorryWeDontHave', context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: _isLandScape
                          ? screenUtil.setSp(30)
                          : screenUtil.setSp(40),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                      wordSpacing: 1,
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: _isLandScape ? 5 : 15),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: _isLandScape ? 1 : 5,
                  mainAxisSpacing: _isLandScape ? 1 : 5,
                ),
                itemCount: products.fruitesProducts.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: products.fruitesProducts[index],
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
            ),
    );
  }
}
