import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/screens/my-orders_screen.dart';
import 'package:tiffinbox/screens/payment_screen.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/services/cart-service.dart';
import 'package:tiffinbox/services/order-service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  dynamic _selectedAddress; // State variable to store selected address
  String _selectedAddressId = '';
  List<dynamic> _savedAddresses = []; // List to store saved addresses
  dynamic _defaultAddress; // State variable to store default address
  dynamic _selectedPaymentMethod; // State variable to store selected payment method
  @override
  void initState() {
    super.initState();
    // Fetch default address and saved addresses from AddressProvider or any other source
    _fetchAddresses();
    _fetchPaymentDetails();

    // Set default address to the first address in the list
    if (_savedAddresses.isNotEmpty) {
      _defaultAddress = _savedAddresses.firstWhere(
        (address) => address['is_default'] == true,
        orElse: () => _savedAddresses[0], // Default to the first address if no default found
      );
      _selectedAddress = '${_defaultAddress['addressLine1']} ${_defaultAddress['addressLine2']}';
      _selectedAddressId = _defaultAddress['id'];
    } else {
      _selectedAddress = 'No saved addresses'; // Handle case where no addresses are available
    }

    _selectedPaymentMethod = 'Cash on Delievery';

    setState(() {}); // Trigger rebuild after setting the default address
  }

  void _fetchPaymentDetails() async {
    // Fetch payment details from PaymentProvider or any other source

    setState(() {}); // Trigger rebuild after setting the payment details
  }

  void _fetchAddresses() async {
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
              onPressed: _placeOrder,
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
                return DropdownMenuItem<String>(
                  value: address['addressLine1'] + ' ' + address['addressLine2'],
                  child: Text(address['addressLine1'] + ' ' + address['addressLine2']),
                );
              },
            ).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedAddress = newValue;
                _selectedAddressId = _savedAddresses
                    .firstWhere((address) => address['addressLine1'] + ' ' + address['addressLine2'] == newValue)['id'];
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
        const SizedBox(height: 8),
        Text(
          _selectedPaymentMethod,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () async {
            final selectedPaymentMethod = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentMethodScreen(_selectedPaymentMethod),
              ),
            );
            if (selectedPaymentMethod != null) {
              setState(() {
                _selectedPaymentMethod = selectedPaymentMethod;
              });
            }
          },
          child: const Text('Select Payment Method'),
        ),
      ],
    );
  }

  void _placeOrder() {
    // check if all teh required information of delievery address and paynement is provided
    // if not, show a snackbar
    if (_selectedAddress == null || _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide all the required information.'),
        ),
      );
    } else {
      // proceed with the order
      _createOrder();      
    } 
  }

  Future<void> _createOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    print(_savedAddresses);
    _selectedAddressId = 
      _savedAddresses.firstWhere((element) => 
        element['addressLine1'] + ' ' + element['addressLine2'] == _selectedAddress)
        ['id'];
    print(_selectedAddressId);

    final order = {
      "user_id" : FirebaseAuth.instance.currentUser!.uid,
      'address': _selectedAddressId,
      'payment': _selectedPaymentMethod,
      'items': cartProvider.cartItems
          .map((item) => {
                'name': item.name,
                'quantity': item.quantity,
                'price': item.price,
              })
          .toList(),
      'total': cartProvider.totalAmount,
    };

    var response = await OrderService().placeOrder(order);

    if (response['status'] == 'success') {
      cartProvider.clearCart();
      print(response['orders']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyOrdersScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
        ),
      );
    }
  }

}
