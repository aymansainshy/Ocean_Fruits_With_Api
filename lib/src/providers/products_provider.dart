import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';
import '../models/dilevery_time_model.dart';

class Products with ChangeNotifier {
  final String userId;
  Dio dio = Dio();
  double _deliverFee;
  String _adImage;

  List<Product> _recommendedProducts = [];
  List<Product> _categoryProducts = [];

  Products(this.userId);

  List<Product> get recommendeProducts => [..._recommendedProducts];
  List<Product> get categoryProdocts => [..._categoryProducts];

  double get delveryFee {
    return _deliverFee;
  }

  String get adsImage {
    return _adImage;
  }

  // List<Product> get favoritesProducts {
  //   return _recommendedProducts.where((product) => product.isFavorits).toList();
  // }

  List<Product> get fruitesProducts {
    return _recommendedProducts.where((product) => product.isFruit).toList();
  }

  List<Product> get vegetableProduct {
    return _recommendedProducts.where((product) => !product.isFruit).toList();
  }

  List<Product> _favProduct = [];
  List<Product> get favProduct {
    return [..._favProduct];
  }

  List<DileveryTime> _dileveryTime = [];
  List<DileveryTime> get dileveryTime {
    return [..._dileveryTime];
  }

  bool isFavContainProductId(String id) {
    if (_favProduct.isEmpty || _favProduct == null) {
      return false;
    }
    List<String> _favProductId = _favProduct.map((_fav) {
      return _fav.id;
    }).toList();

    if (_favProductId.contains(id)) {
      return true;
    }
    return false;
  }

  Future<void> fetchFavoritesProducts(String userId) async {
    Dio dio = Dio();
    var url = 'https://veget.ocean-sudan.com/api/user/favort';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'user_id': userId,
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

      final responseData = response.data as List<dynamic>;

      List<Product> _productData = [];
      responseData.forEach(
        (product) {
          _productData.add(
            Product(
              id: product["product"]["id"].toString(),
              imageUrl:
                  "https://veget.ocean-sudan.com" + product["product"]["image"],
              price: double.parse(product["product"]["price"]),
              discount: double.parse(product["product"]["discount"]),
              isFruit: (product["product"]["type"] as String).contains("1")
                  ? true
                  : false,
              arTitle: product["product"]["name_ar"],
              enTitle: product["product"]["name_en"],
              unit: product["product"]["unit_id"].toString(),
              isFavorits: true,
            ),
          );
        },
      );
      _favProduct = _productData;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchCategoryProducts(String catId) async {
    Dio dio = Dio();
    var url = 'https://veget.ocean-sudan.com/api/catogry/$catId';
    try {
      final response = await dio.get(
        url,
        options: Options(
          sendTimeout: 3000,
          receiveTimeout: 3000,
          headers: {
            'content-type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (userId != null) {
        await fetchFavoritesProducts(userId);
      }

      final responseData = response.data["product"] as List<dynamic>;

      List<Product> _productData = [];
      responseData.forEach(
        (product) {
          bool isFavorits = isFavContainProductId(product["id"].toString());

          _productData.add(Product(
            id: product["id"].toString(),
            imageUrl: "https://veget.ocean-sudan.com" + product["image"],
            price: double.parse(product["price"]),
            discount: double.parse(product["discount"]),
            isFruit: (product["type"] as String).contains("1") ? true : false,
            arTitle: product["name_ar"],
            enTitle: product["name_en"],
            unit: product["unit_id"].toString(),
            isFavorits: isFavorits,
          ));
        },
      );
      _categoryProducts = _productData;

      // print("Response Product Data ..." + _categoryProducts.toString());
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchProducts() async {
    const url = 'https://veget.ocean-sudan.com/api';
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
      final dileveryTime = responseData["delivery_time"] as List<dynamic>;

      if (userId != null) {
        await fetchFavoritesProducts(userId);
      }

      List<Product> _productsListData = [];
      productResponse.forEach((product) {
        bool isFavorits = isFavContainProductId(product["id"].toString());

        _productsListData.add(
          Product(
            id: product["id"].toString(),
            imageUrl: "https://veget.ocean-sudan.com" + product["image"],
            price: double.parse(product["price"]),
            discount: double.parse(product["discount"]),
            isFruit: (product["type"] as String).contains("1") ? true : false,
            arTitle: product["name_ar"],
            enTitle: product["name_en"],
            unit: product["unit_id"].toString(),
            isFavorits: isFavorits,
          ),
        );
      });

      _recommendedProducts = _productsListData;

      adAndDeliveryFeeResponse.forEach((e) {
        _adImage = "https://veget.ocean-sudan.com/" + e["ad_image"];
        _deliverFee = double.parse(e["deliver_fee"]);
      });

      List<DileveryTime> _dileveryTimeList = [];
      dileveryTime.forEach((time) {
        _dileveryTimeList.add(
          DileveryTime(
            id: time["id"].toString(),
            startTime: time["start_time"].toString(),
            endTime: time["end_time"].toString(),
          ),
        );
      });

      _dileveryTime = _dileveryTimeList;
      notifyListeners();
    } catch (e) {
      // print("Error Massege ...." + e.toString());
      throw e;
    }
  }
}
