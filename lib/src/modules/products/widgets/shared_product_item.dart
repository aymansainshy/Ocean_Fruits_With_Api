import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ocean_fruits/src/core/utils/assets_utils.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_alert_not_autherazed.dart';
import '../../cart/provider/cart_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../lang/provider/language_provider.dart';
import '../models/product_model.dart';
import '../../../core/utils/app_constant.dart';

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

    final userData = Provider.of<AuthProvider>(context, listen: false);

    Carts cart = Provider.of<Carts>(context);

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
          height: 200,
          width: 200,
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
                    AssetsUtils.heartIcon,
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
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(left: 8),
                child: Text(
                  productTitle,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: _isLandScape
                        ? screenUtil.setSp(25)
                        : language == "ar"
                            ? screenUtil.setSp(40)
                            : screenUtil.setSp(45),
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Padding(
                padding: language == "ar"
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(left: 8),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: product.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _isLandScape
                              ? screenUtil.setSp(25)
                              : language == "ar"
                                  ? screenUtil.setSp(40)
                                  : screenUtil.setSp(45),
                          color: AppColors.greenColor,
                        ),
                      ),
                      TextSpan(
                        text: "SDG",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: _isLandScape
                              ? screenUtil.setSp(20)
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
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(left: 8),
                child: Text(
                  "1 $productUnit",
                  style: TextStyle(
                    fontSize: _isLandScape
                        ? screenUtil.setSp(25)
                        : screenUtil.setSp(28),
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 2),
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
                          child: SizedBox(
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
                          productDiscount: product.discount,
                          productUnit: productUnit,
                          productTitle: productTitle,
                          productImage: product.imageUrl,
                        );
                      },
                      child: Container(
                        // color: Colors.green,
                        padding: const EdgeInsets.all(1),
                        height: _isLandScape
                            ? screenUtil.setHeight(250)
                            : screenUtil.setHeight(120),
                        width: _isLandScape
                            ? screenUtil.setWidth(90)
                            : screenUtil.setWidth(120),
                        child: Image.asset(
                          AssetsUtils.plusWithCircleIcon,
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
                decoration: const BoxDecoration(
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
              SizedBox(
                // color: Colors.green,
                height: _isLandScape
                    ? screenUtil.setHeight(460)
                    : screenUtil.setHeight(230),
                width: _isLandScape
                    ? screenUtil.setWidth(170)
                    : screenUtil.setWidth(230),
                child: Image.network(
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

  BoxShadow boxShadow() {
    return const BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      spreadRadius: 0.1,
      offset: Offset(0.5, 3),
    );
  }
}
