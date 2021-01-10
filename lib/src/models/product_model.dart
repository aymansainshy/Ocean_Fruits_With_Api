import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final double discount;
  final String imageUrl;
  final int unit;
  final bool isFruit;
  bool isFavorits;

  Product({
    @required this.id,
    @required this.title,
    @required this.isFruit,
    @required this.discount,
    @required this.price,
    @required this.imageUrl,
    @required this.unit,
    this.isFavorits = false,
  });

  void toggleFavorites() {
    isFavorits = !isFavorits;
    notifyListeners();
  }
}
