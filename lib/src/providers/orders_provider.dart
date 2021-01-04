import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/http_exception.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  List<Order> upComingOrder() {
    return _orders
        .where((order) => order.orderStatus == 0 || order.orderStatus == 1)
        .toList();
  }

  List<Order> pastOrder() {
    return _orders.where((order) => order.orderStatus == 2).toList();
  }

  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  // Future<void> fetchOrder(String userId) async {
  //   print('Star fetch Order ........');
  //   print('usder ID ' + userId);
  //   Dio dio = Dio();
  //   final url = 'https://backend.bdcafrica.site/api/user/order';

  //   try {
  //     final response = await dio.get(
  //       url,
  //       queryParameters: {
  //         "user_id": int.parse(userId),
  //       },
  //       options: Options(
  //         sendTimeout: 2000,
  //         receiveTimeout: 1000,
  //         headers: {
  //           'content-type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );

  //     final responseDate = response.data as List<dynamic>;

  //     final List<Order> _orderData = [];
  //     responseDate.forEach((order) {
  //       _orderData.add(
  //         Order(
  //           id: order["id"].toString(),
  //           name: order["name"],
  //           dateTime: DateTime.parse(order["dateTime"].toString()),
  //           totalAmount: double.parse(order["total_price"].toString()),
  //           totalDiscount: double.parse(order["toatal_discount"].toString()),
  //           orderStatus: int.parse(order["order_status"].toString()),
  //           meals: (order["meals_list"] as List<dynamic>)
  //               .map((meal) => Cart(
  //                     mealId: meal["id"].toString(),
  //                     quantity: int.parse(meal["quntity"].toString()),
  //                     mealTitle: meal["meals"]["name"],
  //                     mealPrice: double.parse(meal["price"].toString()),
  //                     mealImage: 'http://backend.bdcafrica.site' +
  //                         meal["meals"]["image_full_path"],
  //                   ))
  //               .toList(),
  //         ),
  //       );
  //     });
  //     _orders = _orderData;
  //     notifyListeners();
  //   } on DioError catch (e) {
  //     throw e.response.data["code"];
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  // Future<void> addOrder({
  //   @required String userId,
  //   @required String userName,
  //   @required String address,
  //   @required String phoneNumber,
  //   @required double totalAmount,
  //   @required String paymentMethod,
  //   @required List<Cart> cartMeals,
  // }) async {
  //   Dio dio = Dio();
  //   final url = 'https://backend.bdcafrica.site/api/user/order';
  //   print("Star Post Order .......");
  //   Map<String, dynamic> data = {
  //     "name": userName,
  //     "address": address,
  //     "phone": phoneNumber,
  //     "dateTime": DateTime.now().toIso8601String(),
  //     "user_id": userId,
  //     "total_price": totalAmount.toString(),
  //     "payment_mthod_id": paymentMethod,
  //     "meals_list": cartMeals
  //         .map((meal) => {
  //               "meals_id": meal.mealId,
  //               "quntity": meal.quantity.toString(),
  //             })
  //         .toList(),
  //   };

  //   try {
  //     await dio.post(
  //       url,
  //       data: jsonEncode(data),
  //       options: Options(
  //         sendTimeout: 2000,
  //         receiveTimeout: 1000,
  //         headers: {
  //           'content-type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  // Future<void> cancelOrder(String orderId) async {
  //   print('Star Canceling Order ........');
  //   print('order id ......... ' + orderId);
  //   Dio dio = Dio();
  //   final url = 'httpS://backend.bdcafrica.site/api/user/order/$orderId/cancel';

  //   try {
  //     final response = await dio.post(
  //       url,
  //       options: Options(
  //         sendTimeout: 2000,
  //         receiveTimeout: 1000,
  //         headers: {
  //           'content-type': 'application/json',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );

  //     print("Response Data .........." + response.data.toString());
  //     print("Response Stause Code .........." + response.statusCode.toString());
  //     print("Response Message .......... " + response.statusMessage.toString());
  //   } on DioError catch (e) {
  //     print("Catch Dio Error " + e.toString());
  //     HttpException(throw e.response.data["code"]);
  //   } catch (e) {
  //     print("Normal error ........." + e.response.toString());
  //     throw e;
  //   }
  // }
}
