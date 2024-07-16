import 'package:flutter/material.dart';

class OrderStatusScreen extends StatelessWidget {
  const OrderStatusScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Status'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: 3339',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text('Order Date: August 01, 2022'),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/paneerbiryani.jpg',
                    width: 80,
                    height: 80,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subway Special',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹1260',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('Qty: 1'),
                        ],
                      ),
                      Text(
                        'Accepted',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                children: [
                  _buildOrderStatusItem('Order Received', '10:00 PM', true),
                  _buildOrderStatusItem('Order Accepted', '10:02 PM', true),
                  _buildOrderStatusItem('Order Prepared', '10:15 PM', true),
                  _buildOrderStatusItem('Order Pickup', '', false),
                  _buildOrderStatusItem('Order Delivered', '', false),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Delivery Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '4517 Washington Ave. Manchester, Kentucky 39495',
              ),
              SizedBox(height: 16),
              Divider(), // Added horizontal line
              Text(
                'Order Summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildOrderSummaryItem('Item Total', '₹1260'),
              _buildOrderSummaryItem('Service Charge', '₹80'),
              _buildOrderSummaryItem('Delivery Fee', '₹100', isFree: true),
              Divider(),
              _buildOrderSummaryItem('Grand Total', '₹1440', isBold: true),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Cancel Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatusItem(String status, String time, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.circle,
                color: isCompleted ? Colors.red : Colors.grey,
              ),
              if (status != 'Order Delivered')
                _buildVerticalDotLine(isCompleted: isCompleted),
            ],
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: isCompleted ? Colors.red : Colors.black,
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                SizedBox(height: 4),
                // Text(time),
              ],
            ),
          ),
          Text(time),
        ],
      ),
    );
  }

  Widget _buildVerticalDotLine({required bool isCompleted}) {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          width: 2,
          height: 8,
          margin: EdgeInsets.symmetric(vertical: 2),
          color: isCompleted ? Colors.red : Colors.grey,
        );
      }),
    );
  }

  Widget _buildOrderSummaryItem(String title, String amount,
      {bool isFree = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isFree ? Colors.green : Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrderStatusScreen(),
  ));
}