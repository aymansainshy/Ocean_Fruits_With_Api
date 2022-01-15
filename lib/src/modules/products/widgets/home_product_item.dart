import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/core/utils/app_constant.dart';
import 'package:ocean_fruits/src/modules/products/models/product_model.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_alert_not_autherazed.dart';
import '../../cart/provider/cart_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../lang/provider/language_provider.dart';
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

    final userData = Provider.of<AuthProvider>(context, listen: false);

    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;

    final productUnit = langugeProvider.unitTile(product.unit);

    final productTitle = language == "ar" ? product.arTitle : product.enTitle;

    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.center,
      children: [
        Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
            boxShadow: [
              boxShadow(),
            ],
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.green,
                margin: language == "ar"
                    ? EdgeInsets.only(right: 3, top: isLandScape ? 8 : 0)
                    : EdgeInsets.only(left: 3, top: isLandScape ? 8 : 1),
                height: isLandScape
                    ? screenUtil.setHeight(220)
                    : screenUtil.setHeight(80),
                width: isLandScape
                    ? screenUtil.setWidth(100)
                    : screenUtil.setWidth(80),
                child: InkWell(
                  onTap: () {
                    if (!userData.isAuth) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomAlertNotAutherazed(
                          color: Colors.yellow[800],
                          topText: translate("notAuthorized", context),
                          bottomText: translate("please", context),
                          iconData: Icons.priority_high,
                        ),
                      );
                      return;
                    }

                    product.toggleFavorites(userData.userId);
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
              if (language == "en") SizedBox(height: isLandScape ? 5 : 0),
              Padding(
                padding: language == "ar"
                    ? const EdgeInsets.only(right: 6)
                    : const EdgeInsets.only(left: 6),
                child: Text(
                  productTitle,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: isLandScape
                        ? screenUtil.setSp(28)
                        : screenUtil.setSp(30),
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: language == "ar" ? 0 : 1),
              Padding(
                padding: language == "ar"
                    ? const EdgeInsets.only(right: 6)
                    : const EdgeInsets.only(left: 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: product.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: language == "ar"
                              ? screenUtil.setSp(26)
                              : screenUtil.setSp(32),
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
                    ? const EdgeInsets.only(right: 6)
                    : const EdgeInsets.only(left: 6),
                child: Text(
                  "1 $productUnit",
                  style: TextStyle(
                    fontSize: screenUtil.setSp(25),
                    color: Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(height: language == "ar" ? 0 : 2),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              if (cart.items.containsKey(product.id))
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
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
                          child: SizedBox(
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
                          child: SizedBox(
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
                          productDiscount: product.discount,
                          productUnit: productUnit,
                          productPrice: product.price,
                          productTitle: productTitle,
                          productImage: product.imageUrl,
                        );
                      },
                      child: Container(
                        // color: Colors.green,
                        padding: const EdgeInsets.all(1),
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
                decoration: const BoxDecoration(
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
              SizedBox(
                // color: Colors.green,
                height: isLandScape
                    ? screenUtil.setHeight(460)
                    : screenUtil.setHeight(160),
                width: isLandScape
                    ? screenUtil.setWidth(170)
                    : screenUtil.setWidth(160),
                child: Image.network(
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

  BoxShadow boxShadow() {
    return const BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 0.1,
      offset: Offset(0.5, 3),
    );
  }
}
