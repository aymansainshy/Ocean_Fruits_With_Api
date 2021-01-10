import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../utils/app_constant.dart';
import '../lang/language_provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';

class SharedProductItem extends StatefulWidget {
  const SharedProductItem({
    Key key,
  }) : super(key: key);

  @override
  _SharedProductItemState createState() => _SharedProductItemState();
}

class _SharedProductItemState extends State<SharedProductItem> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var _isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    Product product = Provider.of<Product>(context, listen: false);
    Carts cart = Provider.of<Carts>(context);

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                spreadRadius: 0.1,
                offset: Offset(0.5, 3),
              ),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.green,
                margin: language == "ar"
                    ? EdgeInsets.only(right: 3, top: _isLandScape ? 8 : 2)
                    : EdgeInsets.only(left: 3, top: _isLandScape ? 8 : 2),
                height: _isLandScape
                    ? screenUtil.setHeight(230)
                    : screenUtil.setHeight(130),
                width: _isLandScape
                    ? screenUtil.setWidth(120)
                    : screenUtil.setWidth(130),
                child: InkWell(
                  onTap: () {
                    product.toggleFavorites();
                    setState(() {});
                  },
                  child: Image.asset(
                    "assets/icons/hart empty.png",
                    fit: BoxFit.contain,
                    color: product.isFavorits
                        ? AppColors.redColor
                        : Colors.grey.shade300,
                  ),
                ),
              ),
              SizedBox(height: _isLandScape ? 5 : 3),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 8)
                    : EdgeInsets.only(left: 8),
                child: language == "ar"
                    ? Text(
                        "${product.arTitle}",
                        style: TextStyle(
                          fontSize: _isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(50),
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "${product.enTitle}",
                        style: TextStyle(
                          fontSize: _isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(50),
                          color: Colors.black,
                        ),
                      ),
              ),
              SizedBox(height: 1),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 8)
                    : EdgeInsets.only(left: 8),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(45),
                          color: AppColors.greenColor,
                        ),
                      ),
                      TextSpan(
                        text: "SDG",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: _isLandScape
                              ? screenUtil.setSp(25)
                              : screenUtil.setSp(33),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 8)
                    : EdgeInsets.only(left: 8),
                child: Text(
                  "1 kg",
                  style: TextStyle(
                    fontSize: _isLandScape
                        ? screenUtil.setSp(25)
                        : screenUtil.setSp(28),
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 2),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              if (cart.items.containsKey(product.id))
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.scondryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            var singleItemCount =
                                cart.singleItemCount(product.id);
                            if (singleItemCount <= 1) {
                              cart.removeItem(product.id);
                            }
                            cart.decreaseQuantitiy(product.id);
                          },
                          child: Container(
                            // color: Colors.red,
                            height: _isLandScape
                                ? screenUtil.setHeight(180)
                                : screenUtil.setHeight(120),
                            width: screenUtil.setWidth(100),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: _isLandScape
                                  ? screenUtil.setSp(60)
                                  : screenUtil.setSp(75),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: _isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(40),
                          backgroundColor: AppColors.circleColor,
                          child: Text(
                            "${cart.singleItemCount(product.id)}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: _isLandScape
                                  ? screenUtil.setSp(35)
                                  : screenUtil.setSp(40),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cart.increaseQuantitiy(product.id);
                          },
                          child: Container(
                            height: _isLandScape
                                ? screenUtil.setHeight(200)
                                : screenUtil.setHeight(120),
                            width: screenUtil.setWidth(100),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: _isLandScape
                                  ? screenUtil.setSp(60)
                                  : screenUtil.setSp(75),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!cart.items.containsKey(product.id))
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        cart.addItem(
                          productId: product.id,
                          productPrice: product.price,
                          productTitle: language == "ar"
                              ? product.arTitle
                              : product.enTitle,
                          productImage: product.imageUrl,
                        );
                      },
                      child: Container(
                        // color: Colors.green,
                        padding: EdgeInsets.all(1),
                        height: _isLandScape
                            ? screenUtil.setHeight(250)
                            : screenUtil.setHeight(120),
                        width: _isLandScape
                            ? screenUtil.setWidth(90)
                            : screenUtil.setWidth(120),
                        child: Image.asset(
                          "assets/icons/plus with circle.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        Positioned(
          top: _isLandScape ? 40 : -14,
          right: language == "ar"
              ? null
              : _isLandScape
                  ? 20
                  : -5,
          left: language == "en"
              ? null
              : _isLandScape
                  ? 20
                  : -5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: _isLandScape
                    ? screenUtil.setHeight(230)
                    : screenUtil.setHeight(100),
                width: _isLandScape
                    ? screenUtil.setWidth(230)
                    : screenUtil.setWidth(100),
                decoration: BoxDecoration(
                  // color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 0.1,
                      offset: Offset(-10, 12),
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.green,
                height: _isLandScape
                    ? screenUtil.setHeight(460)
                    : screenUtil.setHeight(230),
                width: _isLandScape
                    ? screenUtil.setWidth(170)
                    : screenUtil.setWidth(230),
                child: Image.asset(
                  product.imageUrl,
                  fit: _isLandScape ? BoxFit.contain : BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
