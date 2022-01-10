import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../lang/provider/language_provider.dart';

import '../provider/cart_provider.dart';
import '../../../core/utils/app_constant.dart';

class CartItem extends StatefulWidget {
  final String productId;
  final String productTitle;
  final String productUnit;
  final int quantity;
  final double productPrice;
  final String productImage;
  final isLandScape;
  final ScreenUtil screenUtil;

  CartItem({
    Key key,
    this.isLandScape,
    this.screenUtil,
    @required this.productId,
    @required this.productUnit,
    @required this.productTitle,
    @required this.quantity,
    @required this.productPrice,
    @required this.productImage,
  }) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    final cart = Provider.of<Carts>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      height: widget.isLandScape
          ? widget.screenUtil.setHeight(500)
          : widget.screenUtil.setHeight(250),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        elevation: 3.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                child: Container(
                  // color: Colors.red,
                  child: Image.network(
                    widget.productImage,
                    fit: BoxFit.contain,
                  ),
                  height: widget.isLandScape
                      ? widget.screenUtil.setHeight(440)
                      : widget.screenUtil.setHeight(220),
                  width: widget.isLandScape
                      ? widget.screenUtil.setWidth(320)
                      : widget.screenUtil.setWidth(250),
                ),
              ),
              Expanded(
                child: Container(
                  height: widget.isLandScape
                      ? widget.screenUtil.setHeight(420)
                      : widget.screenUtil.setHeight(240),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        widget.productPrice.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: widget.isLandScape
                                          ? widget.screenUtil.setSp(35)
                                          : widget.screenUtil.setSp(45),
                                      color: AppColors.scondryColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: translate("SDG", context),
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: widget.isLandScape
                                          ? widget.screenUtil.setSp(15)
                                          : widget.screenUtil.setSp(25),
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title:
                                        Text(translate("areYouSure", context)),
                                    content: Text(
                                        translate("doYouWantRemove", context)),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          translate("yes", context),
                                          style: TextStyle(
                                            color: AppColors.redColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop(true);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text(
                                          translate("no", context),
                                          style: TextStyle(
                                            color: AppColors.greenColor,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(ctx).pop(false);
                                        },
                                      ),
                                    ],
                                  ),
                                ).then((isOk) {
                                  if (isOk) {
                                    cart.removeItem(widget.productId);
                                  } else {
                                    return;
                                  }
                                });
                              },
                              child: Container(
                                height: widget.isLandScape
                                    ? widget.screenUtil.setHeight(150)
                                    : widget.screenUtil.setHeight(90),
                                width: widget.isLandScape
                                    ? widget.screenUtil.setWidth(130)
                                    : widget.screenUtil.setWidth(90),
                                child: Image.asset(
                                  "assets/icons/cancel.png",
                                  fit: BoxFit.contain,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.productTitle,
                          style: TextStyle(
                            fontSize: widget.isLandScape
                                ? widget.screenUtil.setSp(30)
                                : widget.screenUtil.setSp(40),
                            wordSpacing: 1.0,
                          ),
                        ),
                        if (language == "en")
                          SizedBox(
                            height: widget.screenUtil.setHeight(5),
                          ),
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  "(${widget.quantity} ${widget.productUnit})",
                                  style: TextStyle(
                                    fontSize: widget.isLandScape
                                        ? widget.screenUtil.setSp(25)
                                        : widget.screenUtil.setSp(35),
                                    wordSpacing: 1.0,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                child: Transform.translate(
                                  offset: Offset(0, -5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: AppColors.scondryColor,
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              cart.decreaseQuantitiy(
                                                  widget.productId);
                                            },
                                            child: Container(
                                              height: widget.isLandScape
                                                  ? widget.screenUtil
                                                      .setHeight(120)
                                                  : widget.screenUtil
                                                      .setHeight(60),
                                              width: widget.isLandScape
                                                  ? widget.screenUtil
                                                      .setWidth(110)
                                                  : widget.screenUtil
                                                      .setWidth(80),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                              ),
                                              child: Image.asset(
                                                "assets/icons/minusborder.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Spacer(),
                                        SizedBox(
                                          width: widget.screenUtil.setWidth(10),
                                        ),

                                        Expanded(
                                          child: FittedBox(
                                            child: Text(
                                              '${widget.quantity}',
                                              style: TextStyle(
                                                fontSize: widget.isLandScape
                                                    ? widget.screenUtil
                                                        .setSp(20)
                                                    : widget.screenUtil
                                                        .setSp(45),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: widget.screenUtil.setWidth(10),
                                        ),
                                        // Spacer(),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              cart.increaseQuantitiy(
                                                  widget.productId);
                                            },
                                            child: Container(
                                              height: widget.isLandScape
                                                  ? widget.screenUtil
                                                      .setHeight(120)
                                                  : widget.screenUtil
                                                      .setHeight(60),
                                              width: widget.isLandScape
                                                  ? widget.screenUtil
                                                      .setWidth(110)
                                                  : widget.screenUtil
                                                      .setWidth(80),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                color: Colors.white,
                                              ),
                                              child: Image.asset(
                                                "assets/icons/plusborder.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
