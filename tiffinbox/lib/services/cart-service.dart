import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String? imagePath;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imagePath,
  });
}

class CartProvider extends ChangeNotifier {
    double taxRate = 0.05; // 5% tax
    double deliveryFee = 5.0; // $5 delivery fee
  List<CartItem> _cartItems = []; // Use List<CartItem>

  List<CartItem> get cartItems => _cartItems;

  double get itemTotal {
    double total = 0.0;
    _cartItems.forEach((item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  double get taxTotal {
    return itemTotal * taxRate;
  }

  double get deliveryTotal {
    return deliveryFee;
  }

  double get totalAmount {
    double total = itemTotal;
    // Add tax and delivery fee
    double taxFee = total * taxRate;
    total += taxFee;
    total += deliveryFee;
    return double.parse(total.toStringAsFixed(2));
  }
  void addItem(String id, String name, double price, List<dynamic>? photoUrls, {int quantity = 1}) {
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
        id: id,
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

  void updateItemQuantity(int index, int i) {
    _cartItems[index].quantity = i;
    notifyListeners();
  }
}
