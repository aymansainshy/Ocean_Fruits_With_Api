import 'package:flutter/cupertino.dart';
import '../models/cart_model.dart';

class Carts with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach(
        (key, product) => total += product.productPrice * product.quantity);
    return total;
  }

  double get totalDiscount {
    var totalDis = 0.0;
    _items.forEach((key, product) =>
        totalDis += product.productDiscount * product.quantity);
    return totalDis;
  }

  int singleItemCount(String productId) {
    var cartList = _items.values.toList();
    var currentProduct =
        cartList.firstWhere((product) => product.productId == productId);
    return currentProduct.quantity;
  }

  void addItem({
    String productId,
    String productUnit,
    double productPrice,
    String productTitle,
    String productImage,
    double productDiscount,
  }) {
    if (_items.containsKey(productId)) {
      return;
    } else {
      _items.putIfAbsent(
        productId,
        () => Cart(
          productId: productId,
          productImage: productImage,
          productPrice: productPrice,
          productTitle: productTitle,
          unitTitle: productUnit,
          productDiscount: productDiscount,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void increaseQuantitiy(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    _items.update(
      productId,
      (existingProductItem) => Cart(
        productId: existingProductItem.productId,
        unitTitle: existingProductItem.unitTitle,
        productTitle: existingProductItem.productTitle,
        quantity: existingProductItem.quantity + 1,
        productPrice: existingProductItem.productPrice,
        productDiscount: existingProductItem.productDiscount,
        productImage: existingProductItem.productImage,
      ),
    );
    notifyListeners();
  }

  void decreaseQuantitiy(String productId) {
    if (!_items.containsKey(productId) || _items[productId].quantity <= 1) {
      return;
    }
    _items.update(
      productId,
      (existingProductItem) => Cart(
        productId: existingProductItem.productId,
        unitTitle: existingProductItem.unitTitle,
        productTitle: existingProductItem.productTitle,
        quantity: existingProductItem.quantity - 1,
        productPrice: existingProductItem.productPrice,
        productDiscount: existingProductItem.productDiscount,
        productImage: existingProductItem.productImage,
      ),
    );
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void undoSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    _items.remove(productId);
    notifyListeners();
  }
}
