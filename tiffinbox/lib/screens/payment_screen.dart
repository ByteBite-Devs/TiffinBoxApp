import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentMethodScreen extends StatefulWidget {
  String? selectedPaymentMethod;
  PaymentMethodScreen(this.selectedPaymentMethod, {super.key});

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {  
  var _savedCards;
  @override
  void initState() {
    super.initState();
    _fetchSavedCards();
  }

  void _fetchSavedCards() {

    setState(() {
      _savedCards = 
        [
          {
            'cardNumber': '1234 5678 9012 3456',
            'expiryDate': '01/23',
            'cardHolderName': 'John Doe',
            'isDefault': true
          },
          {
            'cardNumber': '9876 5432 1098 7654',
            'expiryDate': '02/24',
            'cardHolderName': 'Jane Smith',
            'isDefault': false
          }
        ];
    });
  }

  void _onPaymentMethodSelected(String? value) {
    setState(() {
      widget.selectedPaymentMethod = value;
    });
  }

  void _showAddCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Adjust as needed, 0.9 means 90% of screen height
          child: Container(
            padding: EdgeInsets.all(16),
            child: AddCardBottomSheet(),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPaymentMethodTile(
              icon: Icons.money,
              label: 'Cash',
              value: 'Cash on Delievery',
            ),
            _buildPaymentMethodTile(
              imageAsset: 'assets/icons/paypal.png',
              label: 'PayPal',
              value: 'PayPal',
            ),
            _buildPaymentMethodTile(
              icon: Icons.apple,
              label: 'Apple Pay',
              value: 'Apple Pay',
            ),
            _buildPaymentMethodTile(
              icon: Icons.credit_card,
              label: 'Credit Card',
              value: 'Credit Card',
            ),
            _savedCards != null ? 
            Column(
              children: [
                for (var card in _savedCards!)
                  _buildPaymentMethodTile(
                    icon: Icons.credit_card,
                    label: card['cardHolderName'],
                    value: card['cardNumber'],
            ),
            widget.selectedPaymentMethod == 'Credit Card' ? GestureDetector(
              onTap: () {
                _showAddCardBottomSheet(context);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.red),
                    SizedBox(width: 16),
                    Text(
                      'Add New Card',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ) :
            SizedBox.shrink(),
            SizedBox(height: 16), // Use a fixed height instead of Spacer
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.selectedPaymentMethod != null
                    ? () {
                      print(widget.selectedPaymentMethod);
                      Navigator.of(context).pop(widget.selectedPaymentMethod);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.selectedPaymentMethod != null
                      ? Colors.red
                      : Colors.red[100],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: widget.selectedPaymentMethod != null
                        ? Colors.white
                        : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        )
            :
            SizedBox.shrink(),
          ]
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    IconData? icon,
    String? imageAsset,
    required String label,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        _onPaymentMethodSelected(value);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.selectedPaymentMethod == value
                ? Colors.red
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            if (imageAsset != null)
              Image.asset(imageAsset, width: 24, height: 24),
            SizedBox(width: 16),
            Text(label),
            Spacer(),
            Radio<String>(
              value: value,
              groupValue: widget.selectedPaymentMethod,
              onChanged: _onPaymentMethodSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class AddCardBottomSheet extends StatefulWidget {
  @override
  _AddCardBottomSheetState createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  bool get _isFormValid =>
      _cardNumberController.text.isNotEmpty &&
          _cardHolderNameController.text.isNotEmpty &&
          _expiryDateController.text.isNotEmpty &&
          _cvvController.text.isNotEmpty;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String? _validateExpiryDate(String value) {
    // if (value.length != 5) return 'Invalid format';
    final parts = value.split('/');
    if (parts.length != 2) return 'Invalid format';
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    // if (month == null || year == null) return 'Invalid format';
    if (month! < 1 || month > 12) return 'Invalid month';
    if (year! < 20 || year > 50) return 'Invalid year';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _cardNumberController.text.isNotEmpty
                          ? '**** **** **** ${_cardNumberController.text.substring(_cardNumberController.text.length - 4)}'
                          : '**** **** **** ****',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Cardholder Name',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _cardHolderNameController.text.isNotEmpty
                          ? _cardHolderNameController.text
                          : '',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Expiry Date', // Added heading for expiry date
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _expiryDateController.text.isNotEmpty
                          ? _expiryDateController.text
                          : 'MM/YY',
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '**** **** **** ****',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 8),
            TextField(
              controller: _cardHolderNameController,
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'Enter Cardholder Name',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 8),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                labelText: 'Expiry Date',
                hintText: 'MM/YY',
                errorText: _validateExpiryDate(_expiryDateController.text),
              ),
              keyboardType: TextInputType.datetime,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              ],
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 8),
            TextField(
              controller: _cvvController,
              decoration: InputDecoration(
                labelText: 'CVV',
                hintText: '***',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid
                    ? () {
                  Navigator.of(context).pop();
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid ? Colors.red : Colors.red[100],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    color: _isFormValid ? Colors.white : Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiryDateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.length == 2 && !newValue.text.contains('/')) {
      return TextEditingValue(
        text: '${newValue.text}/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }
    return newValue;
  }
}