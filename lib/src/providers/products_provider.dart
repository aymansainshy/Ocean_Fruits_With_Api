import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class Products with ChangeNotifier {
  Dio dio = Dio();
  double _deliverFee;
  String _adImage;

  List<Product> _recommendedProducts = [
    // Product(
    //   id: "1",
    //   imageUrl: "assets/images/fruit1.png",
    //   price: 23.5,
    //   title: "Enab",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "2",
    //   imageUrl: "assets/images/fruit2.png",
    //   price: 23.5,
    //   title: "apple",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "3",
    //   imageUrl: "assets/images/fruit3.png",
    //   price: 25.5,
    //   title: "banana",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "4",
    //   imageUrl: "assets/images/fruit4.png",
    //   price: 55.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "5",
    //   imageUrl: "assets/images/fruit5.png",
    //   price: 10.5,
    //   title: "dates",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "6",
    //   imageUrl: "assets/images/fruit6.png",
    //   price: 23.5,
    //   title: "orange",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "7",
    //   imageUrl: "assets/images/fruit7.png",
    //   price: 19.5,
    //   title: "Enab",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "8",
    //   imageUrl: "assets/images/fruit8.png",
    //   price: 23.5,
    //   title: "Guafa",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "9",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 23.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "10",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 90.5,
    //   title: "Enab",
    //   isFruit: true,
    // ),
    // Product(
    //   id: "11",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 90.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "12",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 90.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "13",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 90.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
    // Product(
    //   id: "14",
    //   imageUrl: "assets/images/fruit9.png",
    //   price: 90.5,
    //   title: "Enab",
    //   isFruit: false,
    // ),
  ];

  List<Product> get recommendeProducts {
    return [..._recommendedProducts];
  }

  double get delveryFee {
    return _deliverFee;
  }

  String get adsImage {
    return _adImage;
  }

  List<Product> get favoritesProducts {
    return _recommendedProducts.where((product) => product.isFavorits).toList();
  }

  List<Product> get fruitesProducts {
    return _recommendedProducts.where((product) => product.isFruit).toList();
  }

  List<Product> get vegetableProduct {
    return _recommendedProducts.where((product) => !product.isFruit).toList();
  }

  Future<Response> fetchProducts() async {
    const url = 'https://veget.ocean-sudan.com/api/';
    try {
      final response = await dio.get(
        url,
        options: Options(
          sendTimeout: 2000,
          receiveTimeout: 1000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data as Map<String, dynamic>;
      final productResponse = responseData["products"] as List<dynamic>;
      final adAndDeliveryFeeResponse = responseData["Config"] as List<dynamic>;

      // if (userId != null) {
      //   await fetchFavoritesMeal(userId);
      // }

      List<Product> _productsListData = [];
      productResponse.forEach(
        (product) => _productsListData.add(
          Product(
            id: product["id"].toString(),
            imageUrl: "https://veget.ocean-sudan.com" + product["image"],
            price: double.parse(product["price"]),
            discount: double.parse(product["discount"]),
            isFruit: product["type"] == 1 ? true : false,
            title: product["name"],
            unit: product["unit_id"],
          ),
        ),
      );

      _recommendedProducts = _productsListData;

      adAndDeliveryFeeResponse.forEach((e) {
        _adImage = "https://veget.ocean-sudan.com/" + e["ad_image"];
        _deliverFee = double.parse(e["deliver_fee"]);
      });
      notifyListeners();

      print("Product List .... " + _recommendedProducts.toString());
      print("Image ADS .... " + _adImage.toString());
      print("dilevery FEE .... " + _deliverFee.toString());
      return response;
    } catch (e) {
      print("Error Massege ...." + e.toString());
      throw e;
    }
  }
}
