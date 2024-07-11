import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
 
class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);
 
  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}
 
class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  int? _selectedPaymentMethod;
 
  void _onPaymentMethodSelected(int? value) {
    setState(() {
      _selectedPaymentMethod = value;
    });
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPaymentMethodTile(
              icon: Icons.money,
              label: 'Cash',
              value: 0,
            ),
            _buildPaymentMethodTile(
              imageAsset: 'assets/icons/paypal.png',
              //               svgIcon: 'assets/icons/paypal.svg',
              label: 'PayPal',
              value: 1,
            ),
            _buildPaymentMethodTile(
              icon: Icons.payment,
              label: 'Google Pay',
              value: 2,
            ),
            _buildPaymentMethodTile(
              icon: Icons.apple,
              label: 'Apple Pay',
              value: 3,
            ),
            _buildPaymentMethodTile(
              icon: Icons.credit_card,
              label: '**** **** **** 0895',
              value: 4,
            ),
            _buildPaymentMethodTile(
              icon: Icons.credit_card,
              label: '**** **** **** 2259',
              value: 5,
            ),
            GestureDetector(
              onTap: () {
                // Add your logic to add a new card
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
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod != null ? () {
                  // Add your logic for applying the selected payment method
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedPaymentMethod != null ? Colors.red : Colors.red[100],
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Apply',
                  style: TextStyle(
                    color: _selectedPaymentMethod != null ? Colors.white : Colors.red,
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
 
  Widget _buildPaymentMethodTile({IconData? icon, String? imageAsset, required String label, required int value}) {
  // Widget _buildPaymentMethodTile({IconData? icon, String? svgIcon, required String label, required int value}) {
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
            color: _selectedPaymentMethod == value ? Colors.red : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) Icon(icon),
            if (imageAsset != null) Image.asset(imageAsset, width: 24, height: 24),
            SizedBox(width: 16),
            Text(label),
            Spacer(),
            Radio<int>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: _onPaymentMethodSelected,
            ),
          ],
        ),
      ),
    );
  }
}