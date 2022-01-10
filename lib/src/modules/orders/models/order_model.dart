import 'package:flutter/material.dart';
import '../../cart/models/cart_model.dart';

class Order {
  final String id;
  final int orderStatus;
  final DateTime dateTime;
  final String deliveryDate;
  final String deliverTime;
  final double totalAmount;
  final double totalDiscount;
  final List<Cart> products;

  Order({
    @required this.id,
    @required this.dateTime,
    this.deliverTime,
    this.deliveryDate, // 0 = Today , 1 = Tomorrow
    @required this.totalAmount,
    @required this.totalDiscount,
    @required this.products,
    @required this.orderStatus,
  });
}
