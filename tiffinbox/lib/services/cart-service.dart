import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final double price;
  int quantity;
  final String? imagePath;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = []; // Use List<CartItem>

  List<CartItem> get cartItems => _cartItems;

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String name, double price, List<dynamic>? photoUrls, {int quantity = 1}) {
    // Check if the item already exists in cart
    bool found = false;
    for (int i = 0; i < _cartItems.length; i++) {
      if (_cartItems[i].name == name) {
        // Item found, update quantity
        _cartItems[i].quantity += quantity;
        found = true;
        break;
      }
    }

    if (!found) {
      // Item not found, add new item
      _cartItems.add(CartItem(
        name: name,
        price: price, // If price is null, set it to 0.0
        quantity: quantity,
        imagePath: photoUrls?.firstOrNull,
      ));
    }

    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void incrementQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decrementQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }
}
