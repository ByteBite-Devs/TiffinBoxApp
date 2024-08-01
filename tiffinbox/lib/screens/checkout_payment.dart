import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/screens/my-orders_screen.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/services/cart-service.dart';
import 'package:tiffinbox/services/order-service.dart';
import '../services/payment.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // PaymentMethodScreen state variables
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'CAD',
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'CAD';
  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      final double amount = double.parse(amountController.text);
      final data = await createPaymentIntent(
        amount: (amount * 100).toInt().toString(),
        currency: selectedCurrency,
        name: nameController.text,
        address: addressController.text,
        pin: pincodeController.text,
        city: cityController.text,
        state: stateController.text,
        country: countryController.text,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            customFlow: false,
            merchantDisplayName: 'Test Merchant',
            paymentIntentClientSecret: data['client_secret'],
            customerEphemeralKeySecret: data['ephemeralKey'],
            customerId: data['id'],
            style: ThemeMode.dark,
            billingDetails: BillingDetails(
              address: Address(
                line1: addressController.text,
                line2: '',
                city: cityController.text,
                country: countryController.text,
                postalCode: pincodeController.text,
                state: stateController.text,
              ),
              name: nameController.text,
              email: FirebaseAuth.instance.currentUser!.email,
            )),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  // CheckoutScreen state variables
  dynamic _selectedAddress;
  String _selectedAddressId = '';
  String _sekectedAddressCity = "", _selectedAddressState = "";
  List<dynamic> _savedAddresses = [];
  dynamic _defaultAddress;
  // dynamic _selectedPaymentMethod = 'Cash on Delivery';

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
    _fetchPaymentDetails();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    amountController.text = cartProvider.totalAmount.toStringAsFixed(2);
    addressController.text = _selectedAddress ?? 'No saved addresses';
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // CheckoutScreen content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderSummary(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.0),
                    Text('Currency:'),
                    DropdownButton<String>(
                      value: selectedCurrency,
                      items: currencyList.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCurrency = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey1,
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey2,
                      child: TextFormField(
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey3,
                      child: TextFormField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: 'City',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter city';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey4,
                      child: TextFormField(
                        controller: stateController,
                        decoration: InputDecoration(
                          labelText: 'State',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey5,
                      child: TextFormField(
                        controller: countryController,
                        decoration: InputDecoration(
                          labelText: 'Country',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter country';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Form(
                      key: formkey6,
                      child: TextFormField(
                        controller: pincodeController,
                        decoration: InputDecoration(
                          labelText: 'Pincode',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter pincode';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          await initPaymentSheet();
                          await Stripe.instance.presentPaymentSheet();
                          var response = await _createOrder();
                          if (response['status'] == 'success') {
                            setState(() {
                              cartProvider.clearCart();
                            });
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const AlertDialog(
                                  title: Icon(Icons.check_circle,
                                      color: Colors.green, size: 80),
                                  content: Text('Payment successful!', textAlign: TextAlign.center,),    
                                );
                              },
                            );

                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyOrdersScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                          }
                        }
                      },
                      child: Text('Pay ${amountController.text} $selectedCurrency'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _selectedAddressId = _savedAddresses.firstWhere((element) =>
        element['addressLine1'] + ' ' + element['addressLine2'] ==
        _selectedAddress)['id'];

    var address = {
      'address': addressController.text,
      'city': cityController.text,
      'state': stateController.text,
      'country': countryController.text,
      'pincode': pincodeController.text,
    };
    final order = {
      "user_id": FirebaseAuth.instance.currentUser!.uid,
      'address': address,
      'items': cartProvider.cartItems
          .map((item) => {
                'id': item.id,
                'name': item.name,
                'quantity': item.quantity,
                'price': item.price,
              })
          .toList(),
      'total': cartProvider.totalAmount,
    };

    return await OrderService().placeOrder(order);
  }

  void _fetchPaymentDetails() async {
    setState(() {});
  }

  _fetchAddresses() async {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    await addressProvider.fetchAddresses();
    _savedAddresses = addressProvider.addresses;
    if (_savedAddresses.isNotEmpty) {
      _defaultAddress = _savedAddresses.firstWhere(
        (address) => address['is_default'] == true,
        orElse: () => _savedAddresses[0],
      );
      _selectedAddress = '${_defaultAddress['addressLine1']} ${_defaultAddress['addressLine2']}';
      setState(() {
        _sekectedAddressCity = "${_defaultAddress['city']}";
        _selectedAddressState = "${_defaultAddress['state']}";
        _selectedAddressId = _defaultAddress['id'];
        addressController.text = _selectedAddress;
        cityController.text = _sekectedAddressCity;
        stateController.text = _selectedAddressState;
        countryController.text = 'Canada';
        nameController.text = FirebaseAuth.instance.currentUser!.displayName ?? '';
      });
    } else {
      setState(() {
        _selectedAddress = 'No saved addresses';
        addressController.text = _selectedAddress;
        nameController.text = FirebaseAuth.instance.currentUser!.displayName ?? '';
      });
    }
  }

  Widget _buildOrderSummary() {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const Divider(),
        const SizedBox(height: 6),
        Text(
          'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
