import 'package:buy_it/model/product.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier {
  List<Product> product = [];

  addProduct(Product product) {
    this.product.add(product);
    notifyListeners();
  }

  removeProduct(Product product) {
    this.product.remove(product);
    notifyListeners();
  }
}
