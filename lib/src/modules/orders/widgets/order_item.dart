import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../lang/provider/language_provider.dart';
import '../provider/orders_provider.dart';
import '../../../core/utils/app_constant.dart';
import '../models/order_model.dart';

// ignore: must_be_immutable
class OrderItem extends StatefulWidget {
  final Order order;
  final bool isLandScape;
  final ScreenUtil screenUtil;
  bool expanded;

  OrderItem({
    Key key,
    this.order,
    this.isLandScape,
    this.screenUtil,
    this.expanded = true,
  }) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isLoading = false;

  void _showArrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(translate("errorOccurred", context)),
        content: Text(message),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(translate("ok", context)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final langugeProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    final language = langugeProvider.appLocal.languageCode;
    final order = Provider.of<Orders>(context, listen: false);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Text(
                  '${translate("dateTime", context)} :',
                  style: TextStyle(
                    fontSize: widget.isLandScape
                        ? widget.screenUtil.setSp(30)
                        : widget.screenUtil.setSp(40),
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat.yMMMMd().format(widget.order.dateTime),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      widget.expanded = !widget.expanded;
                    });
                  },
                  icon: Icon(
                    widget.expanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ),
              ],
            ),
          ),
          // if (widget.expanded)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: widget.expanded
                ? widget.isLandScape
                    ? widget.order.products.length * 40.0
                    : widget.order.products.length * 35.0
                : 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox(
                height: widget.isLandScape
                    ? widget.order.products.length * 40.0
                    : widget.order.products.length * 30.0,
                child: ListView(
                  children: widget.order.products.map((product) {
                    final unitTitle =
                        langugeProvider.unitTile(product.unitTitle);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Text(
                            language == "ar"
                                ? product.productTitle
                                : product.productTitleEn,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${product.quantity}  $unitTitle ',
                            style: TextStyle(
                              fontSize: widget.isLandScape
                                  ? widget.screenUtil.setSp(28)
                                  : widget.screenUtil.setSp(35),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(width: widget.screenUtil.setWidth(70)),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: product.productPrice.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: widget.isLandScape
                                        ? widget.screenUtil.setSp(28)
                                        : widget.screenUtil.setSp(35),
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: translate("SDG", context),
                                  style: TextStyle(
                                    // fontFamily: "Cairo",
                                    color: Colors.black87,
                                    fontSize: widget.isLandScape
                                        ? widget.screenUtil.setSp(20)
                                        : widget.screenUtil.setSp(30),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          if (widget.expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    translate("totalPrice", context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.isLandScape
                          ? widget.screenUtil.setSp(30)
                          : widget.screenUtil.setSp(45),
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '\$${widget.order.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: widget.isLandScape
                                ? widget.screenUtil.setSp(25)
                                : widget.screenUtil.setSp(35),
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: translate("SDG", context),
                          style: TextStyle(
                            // fontFamily: "Cairo",
                            color: Colors.black87,
                            fontSize: widget.isLandScape
                                ? widget.screenUtil.setSp(18)
                                : widget.screenUtil.setSp(28),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.order.orderStatus == 0) Spacer(),
                  if (widget.order.orderStatus == 0)
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textColor: Colors.white,
                      color: AppColors.primaryColor,
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.greenColor,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              translate("cancel", context),
                              style: const TextStyle(fontSize: 12),
                            ),
                      onPressed: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          // await order.cancelOrder(widget.order.id);
                          order.removeOrder(widget.order.id);
                          setState(() {
                            isLoading = false;
                          });
                          var message =
                              translate("orderCanceledSuccess", context);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(translate("done", context)),
                              content: Text(message),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "Ok",
                                    style: TextStyle(
                                      color: AppColors.scondryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } on HttpException catch (e) {
                          var message =
                              translate("anErrorPleaseTryLater", context);
                          if (e.toString() == '7') {
                            message = translate("canNotCanceled", context);
                          }
                          _showArrorDialog(message);
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });

                          var massege =
                              translate("anErrorPleaseTryLater", context);
                          _showArrorDialog(massege);
                        }
                      },
                    )
                ],
              ),
            )
        ],
      ),
    );
  }
}
