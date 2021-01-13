import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';
import '../models/dilevery_time_model.dart';

class Products with ChangeNotifier {
  final String userId;
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

  Products(this.userId);

  List<Product> get recommendeProducts {
    return [..._recommendedProducts];
  }

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
    var url = 'http://veget.ocean-sudan.com/api/user/favort';
    try {
      final response = await dio.get(
        url,
        queryParameters: {
          'user_id': userId ?? 1,
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
          String unit = _unitTile(product["product"]["unit_id"].toString());

          _productData.add(
            Product(
              id: product["product"]["id"].toString(),
              imageUrl:
                  "http://veget.ocean-sudan.com" + product["product"]["image"],
              price: double.parse(product["product"]["price"]),
              discount: double.parse(product["product"]["discount"]),
              isFruit: (product["product"]["type"] as String).contains("1")
                  ? true
                  : false,
              arTitle: product["product"]["name_ar"],
              enTitle: product["product"]["name_en"],
              unit: unit,
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

  Future<void> fetchProducts() async {
    const url = 'http://veget.ocean-sudan.com/api';
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
        String unit = _unitTile(product["unit_id"].toString());
        bool isFavorits = isFavContainProductId(product["id"].toString());

        _productsListData.add(
          Product(
            id: product["id"].toString(),
            imageUrl: "http://veget.ocean-sudan.com" + product["image"],
            price: double.parse(product["price"]),
            discount: double.parse(product["discount"]),
            isFruit: (product["type"] as String).contains("1") ? true : false,
            arTitle: product["name_ar"],
            enTitle: product["name_en"],
            unit: unit,
            isFavorits: isFavorits,
          ),
        );
      });

      _recommendedProducts = _productsListData;

      adAndDeliveryFeeResponse.forEach((e) {
        _adImage = "http://veget.ocean-sudan.com/" + e["ad_image"];
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
      print("Error Massege ...." + e.toString());
      throw e;
    }
  }

  String _unitTile(String unit) {
    switch (unit) {
      case "0":
        return "kh";
        break;
      case "1":
        return "haba";
        break;
      case "2":
        return "kk";
        break;
      case "3":
        return "rr";
        break;
      case "4":
        return "k2h";
        break;
      default:
        return "kg";
    }
  }
}
