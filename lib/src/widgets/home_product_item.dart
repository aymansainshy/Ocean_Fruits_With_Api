import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../lang/language_provider.dart';
import '../utils/app_constant.dart';
import '../models/product_model.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key key,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    ScreenUtil screenUtil = ScreenUtil();
    var isLandScape =
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
          height: 220,
          width: 220,
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
                    ? EdgeInsets.only(right: 3, top: isLandScape ? 8 : 1)
                    : EdgeInsets.only(left: 3, top: isLandScape ? 8 : 1),
                height: isLandScape
                    ? screenUtil.setHeight(220)
                    : screenUtil.setHeight(80),
                width: isLandScape
                    ? screenUtil.setWidth(100)
                    : screenUtil.setWidth(80),
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
              SizedBox(height: isLandScape ? 5 : 0),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 6)
                    : EdgeInsets.only(left: 6),
                child: language == "ar"
                    ? Text(
                        "${product.arTitle}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(34),
                          color: Colors.black,
                        ),
                      )
                    : Text(
                        "${product.enTitle}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: isLandScape
                              ? screenUtil.setSp(30)
                              : screenUtil.setSp(34),
                          color: Colors.black,
                        ),
                      ),
              ),
              SizedBox(height: 1),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 6)
                    : EdgeInsets.only(left: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenUtil.setSp(32),
                          color: AppColors.greenColor,
                        ),
                      ),
                      TextSpan(
                        text: translate("SDG", context),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: screenUtil.setSp(25),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: language == "ar"
                    ? EdgeInsets.only(right: 6)
                    : EdgeInsets.only(left: 6),
                child: Text(
                  "1 kg",
                  style: TextStyle(
                    fontSize: screenUtil.setSp(25),
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
                            height: isLandScape
                                ? screenUtil.setHeight(200)
                                : screenUtil.setHeight(80),
                            width: screenUtil.setWidth(80),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: screenUtil.setSp(60),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: screenUtil.setSp(30),
                          backgroundColor: AppColors.circleColor,
                          child: Text(
                            "${cart.singleItemCount(product.id)}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: screenUtil.setSp(35),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            cart.increaseQuantitiy(product.id);
                          },
                          child: Container(
                            height: isLandScape
                                ? screenUtil.setHeight(200)
                                : screenUtil.setHeight(80),
                            width: screenUtil.setWidth(80),
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: screenUtil.setSp(60),
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
                        height: isLandScape
                            ? screenUtil.setHeight(250)
                            : screenUtil.setHeight(80),
                        width: isLandScape
                            ? screenUtil.setWidth(90)
                            : screenUtil.setWidth(80),
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
          top: isLandScape ? -18 : -14,
          right: language == "ar" ? null : -5,
          left: language == "en" ? null : -5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: isLandScape
                    ? screenUtil.setHeight(200)
                    : screenUtil.setHeight(100),
                width: isLandScape
                    ? screenUtil.setWidth(200)
                    : screenUtil.setWidth(100),
                decoration: BoxDecoration(
                  // color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      spreadRadius: 0.1,
                      offset: Offset(-8, 10),
                    ),
                  ],
                ),
              ),
              Container(
                // color: Colors.green,
                height: isLandScape
                    ? screenUtil.setHeight(460)
                    : screenUtil.setHeight(160),
                width: isLandScape
                    ? screenUtil.setWidth(170)
                    : screenUtil.setWidth(160),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
