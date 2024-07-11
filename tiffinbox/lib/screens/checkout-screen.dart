import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/services/cart-service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  dynamic _selectedAddress; // State variable to store selected address
  List<dynamic> _savedAddresses = []; // List to store saved addresses
  dynamic _defaultAddress; // State variable to store default address
  @override
  void initState() {
    super.initState();
    // Fetch default address and saved addresses from AddressProvider or any other source
    _fetchAddresses();
  }

  void _fetchAddresses() async{
    // Fetch default address and saved addresses from AddressProvider or any other source
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    await addressProvider.fetchAddresses();
    _savedAddresses = addressProvider.addresses;
    if (_savedAddresses.isNotEmpty) {
      _defaultAddress = _savedAddresses.firstWhere(
        (address) => address['is_default'] == true,
      orElse: () => _savedAddresses[0], // Default to the first address if no default found
     );
      _selectedAddress = '${_defaultAddress['addressLine1']} ${_defaultAddress['addressLine2']}';
    } else {
      _selectedAddress = 'No saved addresses'; // Handle case where no addresses are available
    }

    setState(() {}); // Trigger rebuild after setting the address
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDeliveryAddress(),
            const SizedBox(height: 20),
            _buildOrderSummary(),
            const SizedBox(height: 20),
            _buildPaymentOptions(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement order placement logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Delivery Address',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          _selectedAddress ?? 'No address selected',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _showAddressSelectionDialog();
          },
          child: const Text('Change Address'),
        ),
      ],
    );
  }

  void _showAddressSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Address'),
          content: DropdownButton<String>(
            value: _selectedAddress,
            items: _savedAddresses.map(
              (address) {
                print(address);
                return DropdownMenuItem<String>(
                  value: address['addressLine1'] + ' ' + address['addressLine2'],
                  child: Text(address['addressLine1'] + ' ' + address['addressLine2']),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAddress = newValue;
              });
              Navigator.of(context).pop(); // Close dialog
            },
          ),
        );
      },
    );
  }

 Widget _buildOrderSummary() {
  final cartProvider = Provider.of<CartProvider>(context);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Order Summary',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      if (cartProvider.cartItems.isNotEmpty)
        Column(
          children: cartProvider.cartItems.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'x${item.quantity}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      if (cartProvider.cartItems.isEmpty)
        Text(
          'Your cart is empty.',
          style: TextStyle(fontSize: 16),
        ),
      const SizedBox(height: 6),
      const Divider(),
      const SizedBox(height: 6),
      Text(
        'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
    ],
  );
}


  Widget _buildPaymentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Payment Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Placeholder for payment options (e.g., credit card, PayPal)
      ],
    );
  }
}
