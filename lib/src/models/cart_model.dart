import 'package:flutter/cupertino.dart';

class Cart {
  final String productId;
  final String productTitle;
  final int quantity;
  final double productPrice;
  final double productDiscount;
  final String productImage;
  final String unitTitle;

  Cart({
    @required this.productId,
    @required this.productTitle,
    @required this.productPrice,
    @required this.productImage,
    @required this.unitTitle,
    @required this.quantity,
    this.productDiscount,
  });
}
