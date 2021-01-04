import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class Order {
  final String id;
  final String name;
  final int orderStatus;
  final DateTime dateTime;
  DateTime deliverTime = DateTime.now();
  final int deliveryDate;
  final double totalAmount;
  final double totalDiscount;
  final List<Cart> meals;

  Order({
    @required this.id,
    @required this.name,
    @required this.dateTime,
    this.deliverTime,
    this.deliveryDate = 0, // 0 = Today , 1 = Tomorrow
    @required this.totalAmount,
    @required this.totalDiscount,
    @required this.meals,
    @required this.orderStatus,
  });
}
