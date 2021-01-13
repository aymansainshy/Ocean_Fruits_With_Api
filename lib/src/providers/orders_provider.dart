import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/http_exception.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class Orders with ChangeNotifier {
  Dio dio = Dio();
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

  Future<void> fetchOrder(String userId) async {
    print('Star fetch Order ........');
    print('usder ID ' + userId);

    final url = 'http://veget.ocean-sudan.com/api/user/order';

    try {
      final response = await dio.get(
        url,
        queryParameters: {
          "user_id": int.parse(userId),
        },
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("Response Status Code ...." + response.statusCode.toString());
      print("Response Data ...." + response.data.toString());

      final responseDate = response.data as List<dynamic>;

      final List<Order> _orderData = [];
      responseDate.forEach((order) {
        _orderData.add(
          Order(
            id: order["id"].toString(),
            deliverTime: order["deliver_time_id"].toString(),
            deliveryDate: order["deliver_date"].toString(),
            dateTime: DateTime.parse(order["created_at"].toString()),
            totalAmount: double.parse(order["total_price"].toString()),
            totalDiscount: double.parse(order["toatal_discount"].toString()),
            orderStatus: int.parse(order["status"].toString()),
            products: (order["product_list"] as List<dynamic>)
                .map((product) => Cart(
                      productId: product["product_id"].toString(),
                      quantity: int.parse(product["quntity"].toString()),
                      unitTitle: product["product"]["unit_id"].toString(),
                      productPrice:
                          double.parse(product["product"]["price"].toString()),
                      productDiscount: double.parse(
                          product["product"]["discount"].toString()),
                      productTitle: product["product"]["name_ar"],
                      productTitleEn: product["product"]["name_en"],
                      productImage: 'http://veget.ocean-sudan.com/api' +
                          product["product"]["image"],
                    ))
                .toList(),
          ),
        );
      });
      _orders = _orderData;
      notifyListeners();
    } on DioError catch (e) {
      print("Response Error Dio ...." + e.request.toString());
      throw e.response.data["code"];
    } catch (e) {
      print("Response Error ...." + e.toString());
      throw e.toString();
    }
  }

  Future<void> addOrder({
    @required String userId,
    @required String userName,
    @required String address,
    @required String dileveryTime,
    @required String phoneNumber,
    @required String dileveryDate,
    @required String deliveryFee,
    // @required double totalAmount,
    // @required double totalDiscount,
    @required String paymentMethod,
    @required List<Cart> cartProducts,
  }) async {
    final url = 'http://veget.ocean-sudan.com/api/user/order';
    print("Star Post Order .......");
    Map<String, dynamic> data = {
      "user_id": userId,
      "deliver_time_id": dileveryTime,
      "deliver_date": dileveryDate,
      "deliver_fee": deliveryFee,
      "address": address,
      "phone": phoneNumber,
      // "total_price": totalAmount.toString(),
      // "toatal_discount": totalDiscount,
      "payment_mthod_id": paymentMethod,
      "product_list": cartProducts
          .map((product) => {
                "product_id": product.productId,
                "quntity": product.quantity.toString(),
              })
          .toList(),
    };

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      print("Response Status Code ...." + response.statusCode.toString());
      print("Response Data ...." + response.data.toString());
    }

    // on DioError catch (e) {
    //   print("Response DioError...." + e.response.toString());
    //   print("Requeste DioError...." + e.request.toString());
    // }

    catch (e) {
      print("Response Error ...." + e.toString());

      throw e.toString();
    }
  }

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
