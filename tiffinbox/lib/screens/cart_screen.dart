import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/browse_screen.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';
import 'package:tiffinbox/utils/constants/color.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<Map<String, dynamic>> _cartItems = [
    {
      'name': 'Burger With Meat',
      'price': 12230,
      'quantity': 1,
      'imagePath': 'assets/images/lunch.jpeg',
      'selected': true
    },
    {
      'name': 'Ordinary Burgers',
      'price': 12230,
      'quantity': 2,
      'imagePath': 'assets/images/lunch.jpeg',
      'selected': true
    },
    {
      'name': 'Ordinary Burgers',
      'price': 12230,
      'quantity': 1,
      'imagePath': 'assets/images/lunch.jpeg',
      'selected': true
    },
  ];

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildCartWithItems(),
      bottomNavigationBar: const CustomBottomNavigationBar(
          currentIndex: 2), // Set currentIndex to 2 for Cart
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/cart-empty.png', // Replace with your empty cart image path
            height: 200,
          ),
          const SizedBox(height: 16),
          const Text(
            'Ouch! Hungry',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Seems like you have not ordered any food yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BrowseScreen()), // Replace BrowseScreen with your desired screen
              );
              // Navigate to the food menu or home screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primarycolor,
              foregroundColor: Colors.white,// Text color
            ),
            child: const Text('Start Shopping!'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._cartItems.map((item) {
              int index = _cartItems.indexOf(item);
              return _buildCartItem(item, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(
            item['imagePath'],
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item['price']}',
                  style: const TextStyle(color: Colors.orange, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => _decrementQuantity(index),
                    ),
                    Text(item['quantity'].toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _incrementQuantity(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
    );
  }
}
