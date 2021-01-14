import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../screens/check_out_screen.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';
import '../widgets/cart_item.dart';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> tapScaffoldKey;
  bool isTap;
  static const routeName = 'my-cart-screen';
  CartScreen({
    Key key,
    this.tapScaffoldKey,
    this.isTap = false,
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    ScreenUtil screenUtil = ScreenUtil();
    final cart = Provider.of<Carts>(context);

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final _deliveryFee =
        Provider.of<Products>(context, listen: false).delveryFee;
    final language = langugeProvider.appLocal.languageCode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        textTheme: Theme.of(context).textTheme,
        actionsIconTheme: Theme.of(context).accentIconTheme,
        // automaticallyImplyLeading: widget.isTap ? true : false,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        elevation: 0.0,
        leading: widget.isTap
            ? Builder(
                builder: (context) => Transform.translate(
                  offset: Offset(6, 0),
                  child: Padding(
                    padding: language == "ar"
                        ? EdgeInsets.only(left: 10)
                        : EdgeInsets.only(right: 10),
                    child: IconButton(
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
              )
            : Builder(
                builder: (context) => Transform.translate(
                  offset: Offset(6, 0),
                  child: IconButton(
                    padding: language == "ar"
                        ? EdgeInsets.only(right: 15)
                        : EdgeInsets.all(0.0),
                    onPressed: () =>
                        widget.tapScaffoldKey.currentState.openDrawer(),
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
          translate("myCart", context),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: screenUtil.setHeight(700),
                    width: screenUtil.setWidth(700),
                    // color: Colors.red,
                    child: Image.asset(
                      "assets/icons/cart_empty.png",
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
                      translate("emptyCartContent", context),
                      style: TextStyle(
                        fontSize: isLandScape
                            ? screenUtil.setSp(20)
                            : screenUtil.setSp(40),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, i) => CartItem(
                        isLandScape: isLandScape,
                        screenUtil: screenUtil,
                        productId: cart.items.keys.toList()[i],
                        productImage:
                            cart.items.values.toList()[i].productImage,
                        productUnit: cart.items.values.toList()[i].unitTitle,
                        productPrice:
                            cart.items.values.toList()[i].productPrice,
                        productTitle:
                            cart.items.values.toList()[i].productTitle,
                        quantity: cart.items.values.toList()[i].quantity,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate("discount", context)} :",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: isLandScape
                                ? screenUtil.setSp(20)
                                : screenUtil.setSp(40),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${cart.totalDiscount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(25)
                                      : screenUtil.setSp(35),
                                  color: Colors.black54,
                                ),
                              ),
                              TextSpan(
                                text: translate("SDG", context),
                                style: TextStyle(
                                  color: Colors.red,
                                  // fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(15)
                                      : screenUtil.setSp(20),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate("delliveryFee", context)} :",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: isLandScape
                                ? screenUtil.setSp(20)
                                : screenUtil.setSp(40),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${_deliveryFee.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(25)
                                      : screenUtil.setSp(35),
                                  color: Colors.black54,
                                ),
                              ),
                              TextSpan(
                                text: translate("SDG", context),
                                style: TextStyle(
                                  color: Colors.red,
                                  // fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(15)
                                      : screenUtil.setSp(20),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translate("totalPrice", context)} :",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            fontSize: isLandScape
                                ? screenUtil.setSp(25)
                                : screenUtil.setSp(45),
                            color: Colors.black,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${cart.totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(25)
                                      : screenUtil.setSp(45),
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: translate("SDG", context),
                                style: TextStyle(
                                  color: Colors.red,
                                  // fontFamily: 'Cairo',
                                  fontSize: isLandScape
                                      ? screenUtil.setSp(15)
                                      : screenUtil.setSp(35),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2),
                  Center(
                    child: Container(
                      width: isLandScape
                          ? screenUtil.setWidth(800)
                          : double.infinity,
                      height: isLandScape
                          ? screenUtil.setHeight(160)
                          : screenUtil.setHeight(130),
                      margin:
                          isLandScape ? EdgeInsets.all(0) : EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        color: AppColors.scondryColor,
                        child: Text(
                          translate("checkout", context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandScape
                                ? screenUtil.setSp(22)
                                : screenUtil.setSp(45),
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CheckOutScreen.routeName);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
