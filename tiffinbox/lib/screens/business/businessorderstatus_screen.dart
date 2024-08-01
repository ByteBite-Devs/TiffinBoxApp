import 'package:flutter/material.dart';
import 'package:tiffinbox/services/order-service.dart';
import 'package:tiffinbox/utils/custom_bottom_nav.dart';

class BusinessOrderStatusScreen extends StatefulWidget {
  const BusinessOrderStatusScreen({Key? key}) : super(key: key);

  @override
  _BusinessOrderStatusScreen createState() => _BusinessOrderStatusScreen();
}

class _BusinessOrderStatusScreen extends State<BusinessOrderStatusScreen> {
  String selectedFilter = 'All';

  final List<String> statusOptions = [
    'Placed',
    'Shipped',
    'Ready for Delivery',
    'Out for Delivery',
    'Delivered',
    'Cancel'
  ];

  List<dynamic> orders = [];
  List<dynamic> filteredOrders = [];
  Map<String, String> updatedStatuses = {}; // To track updated statuses
  bool showSaveButton = false;
  bool dataLLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    var response = await OrderService().getBusinessOrders();
    if (response['status'] == 'success') {
      setState(() {
        orders = response['orders'];
        filteredOrders = orders;
        filterOrders();
        showSaveButton = false;
        dataLLoaded = true;
      });
    } else {
      setState(() {
        showSaveButton = false;
        dataLLoaded = true;
      });
    }
  }

  filterOrders() async {
    if (selectedFilter == 'All') {
      setState(() {
        filteredOrders = orders;
      });
    } else {
      setState(() {
        filteredOrders = orders
            .where((order) => order['order_status'] == selectedFilter)
            .toList();
      });
    }
    setState(() {
      dataLLoaded = true;
    });
  }

  void _updateStatus(String orderId, String newStatus) {
    setState(() {
      updatedStatuses[orderId] = newStatus;
      showSaveButton = true;
    });
  }

  _saveChanges() async {
    // Save the updated statuses
    for (var entry in updatedStatuses.entries) {
      await OrderService().updateOrderStatus(int.parse(entry.key), entry.value);
    }
    setState(() {
      updatedStatuses.clear();
      showSaveButton = false;
    });
    // Optionally, refetch orders to get updated status
    await fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
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
                  ...['All', ...statusOptions].map((filter) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          setState(() {
                            selectedFilter = filter;
                            filterOrders();
                          });
                        },
                        icon: Icon(_getIconForFilter(filter)),
                        label: Text(_getLabelForFilter(filter)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getColorForFilter(filter),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: dataLLoaded
                    ? filteredOrders.isEmpty
                        ? const Center(child: Text('No Orders Found'))
                        : DataTable(
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
                                DataCell(
                                    Text(order['order_number'].toString())),
                                DataCell(Text(order['user']['name']!)),
                                DataCell(Text(
                                    addressFromJson(order['address']))),
                                DataCell(Text(order['user']['phone'] ?? '')),
                                DataCell(Text(order['tiffin']['name'] ?? '')),
                                DataCell(
                                    Text(order['quantity'].toString() ?? '')),
                                DataCell(Text(order['total'].toString())),
                                DataCell(
                                  order['order_status'] == 'Delivered' ||
                                          order['order_status'] == 'Cancel'
                                      ? const Text('No Action Available')
                                      : DropdownButton<String>(
                                          value: updatedStatuses[
                                                  order['order_number']] ??
                                              order['order_status'],
                                          onChanged: (String? newValue) {
                                            if (newValue!.isNotEmpty) {
                                              setState(() {
                                                order['order_status'] =
                                                    newValue;
                                                _updateStatus(
                                                    order['order_number']
                                                        .toString()!,
                                                    newValue);
                                              });
                                            }
                                          },
                                          items: statusOptions
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                ),
                              ]);
                            }).toList(),
                          )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          if (showSaveButton)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Save Changes'),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBusinessBottomNavigationBar(currentIndex: 1),
    );
  }

  IconData _getIconForFilter(String filter) {
    switch (filter) {
      case 'Placed':
        return Icons.check_circle_outline;
      case 'Shipped':
        return Icons.local_shipping;
      case 'Delivered':
        return Icons.local_shipping_outlined;
      case 'Cancel':
        return Icons.cancel_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _getLabelForFilter(String filter) {
    switch (filter) {
      case 'Placed':
        return 'Order Placed';
      case 'Shipped':
        return 'Shipped';
      case "Ready for Delivery":
        return "Ready for Delivery";
      case "Out for Delivery":
        return "Out for Delivery";
      case 'Delivered':
        return 'Delivered';
      case 'Cancel':
        return 'Cancel';
      default:
        return 'All';
    }
  }

  Color _getColorForFilter(String filter) {
    switch (filter) {
      case 'Placed':
        return Colors.amber;
      case 'Shipped':
        return Colors.grey;
      case 'Ready for Delivery':
        return Colors.blue;
      case 'Out for Delivery':
        return Colors.orange;
      case 'Delivered':
        return Colors.green;
      case 'Cancel':
        return Colors.red;
      default:
        return Colors.pink;
    }
  }

  String addressFromJson(dynamic address) {
    if (address == null) {
      return '';
    }
    return '${address['address']}} ${address['city']} ${address['state']}';
  }
}
