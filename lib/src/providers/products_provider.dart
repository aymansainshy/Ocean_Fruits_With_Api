import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class Products with ChangeNotifier {
  List<Product> _recommendedProducts = [
    Product(
      id: "1",
      imageUrl: "assets/images/fruit1.png",
      price: 23.5,
      title: "Enab",
      isFruit: true,
    ),
    Product(
      id: "2",
      imageUrl: "assets/images/fruit2.png",
      price: 23.5,
      title: "apple",
      isFruit: false,
    ),
    Product(
      id: "3",
      imageUrl: "assets/images/fruit3.png",
      price: 25.5,
      title: "banana",
      isFruit: true,
    ),
    Product(
      id: "4",
      imageUrl: "assets/images/fruit4.png",
      price: 55.5,
      title: "Enab",
      isFruit: false,
    ),
    Product(
      id: "5",
      imageUrl: "assets/images/fruit5.png",
      price: 10.5,
      title: "dates",
      isFruit: true,
    ),
    Product(
      id: "6",
      imageUrl: "assets/images/fruit6.png",
      price: 23.5,
      title: "orange",
      isFruit: true,
    ),
    Product(
      id: "7",
      imageUrl: "assets/images/fruit7.png",
      price: 19.5,
      title: "Enab",
      isFruit: true,
    ),
    Product(
      id: "8",
      imageUrl: "assets/images/fruit8.png",
      price: 23.5,
      title: "Guafa",
      isFruit: true,
    ),
    Product(
      id: "9",
      imageUrl: "assets/images/fruit9.png",
      price: 23.5,
      title: "Enab",
      isFruit: false,
    ),
    Product(
      id: "10",
      imageUrl: "assets/images/fruit9.png",
      price: 90.5,
      title: "Enab",
      isFruit: true,
    ),
    Product(
      id: "11",
      imageUrl: "assets/images/fruit9.png",
      price: 90.5,
      title: "Enab",
      isFruit: false,
    ),
    Product(
      id: "12",
      imageUrl: "assets/images/fruit9.png",
      price: 90.5,
      title: "Enab",
      isFruit: false,
    ),
    Product(
      id: "13",
      imageUrl: "assets/images/fruit9.png",
      price: 90.5,
      title: "Enab",
      isFruit: false,
    ),
    Product(
      id: "14",
      imageUrl: "assets/images/fruit9.png",
      price: 90.5,
      title: "Enab",
      isFruit: false,
    ),
  ];

  List<Product> get recommendeProducts {
    return [..._recommendedProducts];
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
}
