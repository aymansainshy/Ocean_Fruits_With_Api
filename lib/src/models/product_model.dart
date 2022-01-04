import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class Product with ChangeNotifier {
  final String id;
  final String arTitle;
  final String enTitle;
  final double price;
  final double discount;
  final String imageUrl;
  final String unit;
  final bool isFruit;
  bool isFavorits;

  Product({
    @required this.id,
    @required this.arTitle,
    @required this.enTitle,
    @required this.isFruit,
    @required this.discount,
    @required this.price,
    @required this.imageUrl,
    @required this.unit,
    this.isFavorits = false,
  });

  // void toggleFavorites() {
  //   isFavorits = !isFavorits;
  //   notifyListeners();
  // }

  Future<void> toggleFavorites(String userId) async {
    Dio dio = Dio();
    var url = 'https://veget.ocean-sudan.com/api/user/favort';
    final oldStatus = isFavorits;
    isFavorits = !isFavorits;
    notifyListeners();
    try {
      final reponse = await dio.post(
        url,
        data: {
          "user_id": int.parse(userId),
          "product_id": int.parse(id),
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
      print("Respone Status Code ......" + reponse.statusCode.toString());
    } catch (e) {
      print("Error Massage ......" + e.toString());
      isFavorits = oldStatus;
      notifyListeners();
    }
  }
}
