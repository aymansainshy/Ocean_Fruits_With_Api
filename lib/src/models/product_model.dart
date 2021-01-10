import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String arTitle;
  final String enTitle;
  final double price;
  final double discount;
  final String imageUrl;
  final int unit;
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

  void toggleFavorites() {
    isFavorits = !isFavorits;
    notifyListeners();
  }
}
