import 'package:flutter/material.dart';
import 'package:tiffinbox/services/order-service.dart';
import 'package:tiffinbox/services/tiffin-service.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

class BusinessOrderStatusScreen extends StatefulWidget {
  const BusinessOrderStatusScreen({Key? key}) : super(key: key);

  @override
  _BusinessOrderStatusScreen createState() => _BusinessOrderStatusScreen();
}

class _BusinessOrderStatusScreen extends State<BusinessOrderStatusScreen> {
  String status = 'Order Placed';
  String selectedFilter = 'All';

  final List<String> statusOptions = [
    'Placed',
    'Shipped',
    'Delivered',
    'Cancel'
  ];

  List<dynamic> orders = [];
  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    // Fetch orders from the server
    var response = await OrderService().getBusinessOrders();
    if(response['status'] == 'success') {
      setState(() {
        orders = response['orders'];
        print(orders);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredOrders = selectedFilter == 'All'
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
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Shipping Address')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Tiffin')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Total Price')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: filteredOrders.map((order) {
                    return DataRow(cells: [
                      DataCell(Text(order['order_number']!.toString())),
                      DataCell(Text(order['user']['name']!)),
                      DataCell(Text(addressFromJson(order['address']!))),
                      DataCell(Text(order['user']['phone'] ?? '')),
                      DataCell(Text(order['tiffin']['name'] ?? '')),
                      DataCell(Text(order['quantity'].toString() ?? '')),
                      DataCell(Text(order['total'].toString())),
                      DataCell(
                        DropdownButton<String>(
                          value: order['order_status'],
                          onChanged: (String? newValue) {
                            // 
                            print("newValue $newValue");
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
  
  String addressFromJson(address) {
    print(address);
    return address['addressLine1'] + ' ' + address['addressLine2']
    + ' ' + address['city'] + ' ' + address['state'];
  }
}
