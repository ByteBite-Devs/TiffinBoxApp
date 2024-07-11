import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';
import 'package:tiffinbox/utils/constants/color.dart';
import '../services/cart-service.dart';
import 'browse_screen.dart';
import 'checkout-screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: cartProvider.cartItems.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartWithItems(context),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => BrowseScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start Shopping!'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartWithItems(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(cartProvider.cartItems[index], index, context);
            },
          ),
          _buildCartSummary(cartProvider.totalAmount),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CheckoutScreen()), // Navigate to CheckoutScreen
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primarycolor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, int index, BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.asset(
          item.imagePath,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\$${item.price} | Quantity: ${item.quantity}',
          style: const TextStyle(color: Colors.orange, fontSize: 14),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => cartProvider.removeItem(index),
        ),
      ),
    );
  }

  Widget _buildCartSummary(double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Total: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
