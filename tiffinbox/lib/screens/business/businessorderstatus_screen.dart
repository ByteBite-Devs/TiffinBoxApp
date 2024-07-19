import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

class BusinessOrderStatusScreen extends StatefulWidget {
  const BusinessOrderStatusScreen({Key? key}) : super(key: key);

  @override
  _BusinessOrderStatusScreen createState() => _BusinessOrderStatusScreen();
}

class _BusinessOrderStatusScreen extends State<BusinessOrderStatusScreen> {
  String status = 'Order Placed'; // Default status
  String selectedFilter = 'All'; // Default filter

  final List<String> statusOptions = [
    'Order Placed',
    'Shipped',
    'Delivered',
    'Cancel'
  ];

  final List<Map<String, String>> orders = [
    {
      'orderId': '46',
      'customer': 'Admin Admin',
      'address': 'asd',
      'phone': '8989898989',
      'tiffin': 'Lunch',
      'quantity': '1',
      'price': '\$20.00',
      'date': 'July 19, 2024, 4:28 p.m.',
      'status': 'Order Placed'
    },
    // Add more orders here with different statuses
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredOrders = selectedFilter == 'All'
        ? orders
        : orders.where((order) => order['status'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('TiffinBox Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'All';
                      });
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('All'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Order Placed';
                      });
                    },
                    icon: const Icon(Icons.receipt),
                    label: const Text('Order Placed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Shipped';
                      });
                    },
                    icon: const Icon(Icons.local_shipping),
                    label: const Text('Shipped'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Delivered';
                      });
                    },
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Delivered'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedFilter = 'Cancel';
                      });
                    },
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelled'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Order ID')),
                    DataColumn(label: Text('Customer')),
                    DataColumn(label: Text('Shipping Address')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Tiffin')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Order Date')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: filteredOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order['orderId']!)),
                      DataCell(Text(order['customer']!)),
                      DataCell(Text(order['address']!)),
                      DataCell(Text(order['phone']!)),
                      DataCell(Text(order['tiffin']!)),
                      DataCell(Text(order['quantity']!)),
                      DataCell(Text(order['price']!)),
                      DataCell(Text(order['date']!)),
                      DataCell(
                        DropdownButton<String>(
                          value: order['status'],
                          onChanged: (String? newValue) {
                            setState(() {
                              order['status'] = newValue!;
                            });
                          },
                          items: statusOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
          bottomNavigationBar: CustomBusinessBottomNavigationBar(currentIndex: 1),
    );
  }
}
