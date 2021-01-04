import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final bool isFruit;
  bool isFavorits;

  Product({
    @required this.id,
    @required this.title,
    @required this.isFruit,
    @required this.price,
    @required this.imageUrl,
    this.isFavorits = false,
  });

  void toggleFavorites() {
    isFavorits = !isFavorits;
    notifyListeners();
  }
}
