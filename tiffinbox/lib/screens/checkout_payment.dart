import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tiffinbox/services/address-service.dart';
import 'package:tiffinbox/services/cart-service.dart';
import 'package:tiffinbox/services/order-service.dart';
import '../services/payment.dart';
import '../utils/constants/constants.dart';
import 'my-orders_screen.dart';

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
        ),
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
            // Divider(color: Colors.grey),
            // PaymentMethodScreen content
            hasDonated
                ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // "Thanks for your ${amountController.text} $selectedCurrency payment.",
                    "Thank you for your payment.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
                : Padding(
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
                          setState(() {
                            hasDonated = true;
                          });
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

  void _fetchPaymentDetails() async {
    setState(() {});
  }

  void _fetchAddresses() async {
    final addressProvider = Provider.of<AddressProvider>(context, listen: false);
    await addressProvider.fetchAddresses();
    _savedAddresses = addressProvider.addresses;
    if (_savedAddresses.isNotEmpty) {
      _defaultAddress = _savedAddresses.firstWhere(
            (address) => address['is_default'] == true,
        orElse: () => _savedAddresses[0],
      );
      _selectedAddress = '${_defaultAddress['addressLine1']} ${_defaultAddress['addressLine2']}';
      _selectedAddressId = _defaultAddress['id'];
      addressController.text = _selectedAddress;
    } else {
      _selectedAddress = 'No saved addresses';
      addressController.text = _selectedAddress;
    }
    setState(() {});
  }

  // void _showAddressSelectionDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Select Address'),
  //         content: DropdownButton<String>(
  //           value: _selectedAddressId,
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               _selectedAddressId = newValue!;
  //               _selectedAddress = _savedAddresses.firstWhere((address) => address['id'] == newValue)['addressLine1'] +
  //                   ' ' +
  //                   _savedAddresses.firstWhere((address) => address['id'] == newValue)['addressLine2'];
  //               addressController.text = _selectedAddress;
  //             });
  //             Navigator.of(context).pop();
  //           },
  //           items: _savedAddresses.map<DropdownMenuItem<String>>((dynamic address) {
  //             return DropdownMenuItem<String>(
  //               value: address['id'],
  //               child: Text('${address['addressLine1']} ${address['addressLine2']}'),
  //             );
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildOrderSummary() {
  //   final cartProvider = Provider.of<CartProvider>(context);
  //   // final items = cartProvider.items.values.toList();
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Order Summary',
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 8.0),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemCount: items.length,
  //         itemBuilder: (ctx, i) {
  //           return ListTile(
  //             leading: CircleAvatar(
  //               backgroundImage: NetworkImage(items[i].imageUrl),
  //             ),
  //             title: Text(items[i].title),
  //             subtitle: Text('Quantity: ${items[i].quantity}'),
  //             trailing: Text('\$${(items[i].price * items[i].quantity).toStringAsFixed(2)}'),
  //           );
  //         },
  //       ),
  //       const Divider(),
  //       ListTile(
  //         title: const Text('Total'),
  //         trailing: Text('\$${cartProvider.totalAmount.toStringAsFixed(2)}'),
  //       ),
  //     ],
  //   );
  // }

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
          const Text(
            'Your cart is empty.',
            style: TextStyle(fontSize: 16),
          ),
        const SizedBox(height: 6),
        const Divider(),
        const SizedBox(height: 6),
        Text(
          'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}


// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);
//
//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   // PaymentMethodScreen state variables
//   TextEditingController amountController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController addressController = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController stateController = TextEditingController();
//   TextEditingController countryController = TextEditingController();
//   TextEditingController pincodeController = TextEditingController();
//
//   final formkey = GlobalKey<FormState>();
//   final formkey1 = GlobalKey<FormState>();
//   final formkey2 = GlobalKey<FormState>();
//   final formkey3 = GlobalKey<FormState>();
//   final formkey4 = GlobalKey<FormState>();
//   final formkey5 = GlobalKey<FormState>();
//   final formkey6 = GlobalKey<FormState>();
//
//   List<String> currencyList = <String>[
//     'CAD',
//     'USD',
//     'INR',
//     'EUR',
//     'JPY',
//     'GBP',
//     'AED'
//   ];
//   String selectedCurrency = 'CAD';
//   bool hasDonated = false;
//
//   Future<void> initPaymentSheet() async {
//     try {
//       final data = await createPaymentIntent(
//         amount: (int.parse(amountController.text) * 100).toString(),
//         currency: selectedCurrency,
//         name: nameController.text,
//         address: addressController.text,
//         pin: pincodeController.text,
//         city: cityController.text,
//         state: stateController.text,
//         country: countryController.text,
//       );
//
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           customFlow: false,
//           merchantDisplayName: 'Test Merchant',
//           paymentIntentClientSecret: data['client_secret'],
//           customerEphemeralKeySecret: data['ephemeralKey'],
//           customerId: data['id'],
//           style: ThemeMode.dark,
//         ),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       rethrow;
//     }
//   }
//
//   // CheckoutScreen state variables
//   dynamic _selectedAddress;
//   String _selectedAddressId = '';
//   List<dynamic> _savedAddresses = [];
//   dynamic _defaultAddress;
//   dynamic _selectedPaymentMethod = 'Cash on Delivery';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchAddresses();
//     _fetchPaymentDetails();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cartProvider = Provider.of<CartProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // CheckoutScreen content
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // const Text(
//                   //   'Checkout',
//                   //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   // ),
//                   // const SizedBox(height: 16.0),
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     const Text(
//                   //       'Delivery Address:',
//                   //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   //     ),
//                   //     IconButton(
//                   //       icon: const Icon(Icons.edit),
//                   //       onPressed: _showAddressSelectionDialog,
//                   //     ),
//                   //   ],
//                   // ),
//                   // const SizedBox(height: 8.0),
//                   // Text(
//                   //   _selectedAddress,
//                   //   style: const TextStyle(fontSize: 16),
//                   // ),
//                   _buildOrderSummary(),
//                   // const SizedBox(height: 20),
//                   // const SizedBox(height: 16.0),
//                   // const Text(
//                   //   'Order Summary:',
//                   //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   // ),
//                   // const SizedBox(height: 8.0),
//                   // Column(
//                   //   children: cartProvider.cartItems.map((item) {
//                   //     return ListTile(
//                   //       title: Text(item.name),
//                   //       trailing: Text('${item.quantity} x \$${item.price}'),
//                   //     );
//                   //   }).toList(),
//                   // ),
//                   // const SizedBox(height: 8.0),
//                   // Text(
//                   //   'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
//                   //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   // ),
//                   // const SizedBox(height: 16.0),
//                   // const Text(
//                   //   'Payment Method:',
//                   //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   // ),
//                   // const SizedBox(height: 8.0),
//                   // Row(
//                   //   children: [
//                   //     Radio(
//                   //       value: 'Cash on Delivery',
//                   //       groupValue: _selectedPaymentMethod,
//                   //       onChanged: (value) {
//                   //         setState(() {
//                   //           _selectedPaymentMethod = value;
//                   //         });
//                   //       },
//                   //     ),
//                   //     const Text('Cash on Delivery'),
//                   //     Radio(
//                   //       value: 'Online Payment',
//                   //       groupValue: _selectedPaymentMethod,
//                   //       onChanged: (value) {
//                   //         setState(() {
//                   //           _selectedPaymentMethod = value;
//                   //         });
//                   //       },
//                   //     ),
//                   //     const Text('Online Payment'),
//                   //   ],
//                   // ),
//                   // const SizedBox(height: 16.0),
//                   // ElevatedButton(
//                   //   onPressed: _placeOrder,
//                   //   child: const Text('Place Order'),
//                   // ),
//                 ],
//               ),
//             ),
//             // Divider(color: Colors.grey),
//             // PaymentMethodScreen content
//             hasDonated
//                 ? Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Thanks for your ${amountController.text} $selectedCurrency donation",
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             )
//                 : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: formkey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextFormField(
//                       controller: amountController,
//                       decoration: InputDecoration(
//                         labelText: 'Amount',
//                       ),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter amount';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 8.0),
//                     Text('Currency:'),
//                     DropdownButton<String>(
//                       value: selectedCurrency,
//                       items: currencyList.map((String currency) {
//                         return DropdownMenuItem<String>(
//                           value: currency,
//                           child: Text(currency),
//                         );
//                       }).toList(),
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           selectedCurrency = newValue!;
//                         });
//                       },
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey1,
//                       child: TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Name',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey2,
//                       child: TextFormField(
//                         controller: addressController,
//                         decoration: InputDecoration(
//                           labelText: 'Address',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter address';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey3,
//                       child: TextFormField(
//                         controller: cityController,
//                         decoration: InputDecoration(
//                           labelText: 'City',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter city';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey4,
//                       child: TextFormField(
//                         controller: stateController,
//                         decoration: InputDecoration(
//                           labelText: 'State',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter state';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey5,
//                       child: TextFormField(
//                         controller: countryController,
//                         decoration: InputDecoration(
//                           labelText: 'Country',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter country';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 8.0),
//                     Form(
//                       key: formkey6,
//                       child: TextFormField(
//                         controller: pincodeController,
//                         decoration: InputDecoration(
//                           labelText: 'Pincode',
//                         ),
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return 'Please enter pincode';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: 16.0),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (formkey.currentState!.validate()) {
//                           await initPaymentSheet();
//                           await Stripe.instance.presentPaymentSheet();
//                           setState(() {
//                             hasDonated = true;
//                           });
//                         }
//                       },
//                       child: Text('Pay ${amountController.text} $selectedCurrency'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _fetchPaymentDetails() async {
//     setState(() {});
//   }
//
//   void _fetchAddresses() async {
//     final addressProvider = Provider.of<AddressProvider>(context, listen: false);
//     await addressProvider.fetchAddresses();
//     _savedAddresses = addressProvider.addresses;
//     if (_savedAddresses.isNotEmpty) {
//       _defaultAddress = _savedAddresses.firstWhere(
//             (address) => address['is_default'] == true,
//         orElse: () => _savedAddresses[0],
//       );
//       _selectedAddress = '${_defaultAddress['addressLine1']} ${_defaultAddress['addressLine2']}';
//       _selectedAddressId = _defaultAddress['id'];
//     } else {
//       _selectedAddress = 'No saved addresses';
//     }
//     setState(() {});
//   }
//
//   void _showAddressSelectionDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Address'),
//           content: DropdownButton<String>(
//             value: _selectedAddress,
//             items: _savedAddresses.map((address) {
//               return DropdownMenuItem<String>(
//                 value: address['addressLine1'] + ' ' + address['addressLine2'],
//                 child: Text(address['addressLine1'] + ' ' + address['addressLine2']),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedAddress = newValue;
//                 _selectedAddressId = _savedAddresses
//                     .firstWhere((address) => address['addressLine1'] + ' ' + address['addressLine2'] == newValue)['id'];
//               });
//               Navigator.of(context).pop();
//             },
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildOrderSummary() {
//     final cartProvider = Provider.of<CartProvider>(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           'Order Summary',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         if (cartProvider.cartItems.isNotEmpty)
//           Column(
//             children: cartProvider.cartItems.map((item) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Text(
//                         item.name,
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Text(
//                         'x${item.quantity}',
//                         style: TextStyle(fontSize: 16),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         '\$${(item.price * item.quantity).toStringAsFixed(2)}',
//                         style: TextStyle(fontSize: 16),
//                         textAlign: TextAlign.end,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         if (cartProvider.cartItems.isEmpty)
//           Text(
//             'Your cart is empty.',
//             style: TextStyle(fontSize: 16),
//           ),
//         const SizedBox(height: 6),
//         const Divider(),
//         const SizedBox(height: 6),
//         Text(
//           'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//       ],
//     );
//   }
//
//   // void _placeOrder() {
//   //   if (_selectedAddress == null || _selectedPaymentMethod == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('Please provide all the required information.'),
//   //       ),
//   //     );
//   //   } else {
//   //     _createOrder();
//   //   }
//   // }
//
//   // Future<void> _createOrder() async {
//   //   final cartProvider = Provider.of<CartProvider>(context, listen: false);
//   //   _selectedAddressId = _savedAddresses.firstWhere(
//   //           (element) => element['addressLine1'] + ' ' + element['addressLine2'] == _selectedAddress)['id'];
//   //
//   //   final order = {
//   //     "user_id": FirebaseAuth.instance.currentUser!.uid,
//   //     'address': _selectedAddressId,
//   //     'payment': _selectedPaymentMethod,
//   //     'items': cartProvider.cartItems.map((item) => {
//   //       'name': item.name,
//   //       'quantity': item.quantity,
//   //       'price': item.price,
//   //     }).toList(),
//   //     'total': cartProvider.totalAmount,
//   //   };
//   //
//   //   var response = await OrderService().placeOrder(order);
//   //
//   //   if (response['status'] == 'success') {
//   //     cartProvider.clearCart();
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => MyOrdersScreen()),
//   //     );
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text(response['message']),
//   //       ),
//   //     );
//   //   }
//   // }
// }
