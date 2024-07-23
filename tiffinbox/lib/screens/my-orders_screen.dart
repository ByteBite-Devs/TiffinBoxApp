import 'package:flutter/material.dart';
import 'package:tiffinbox/screens/order_tracking_page.dart';
import 'package:tiffinbox/services/order-service.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({Key? key}) : super(key: key);

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();

}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  var orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  _fetchOrders() async {
    var response = await OrderService().getOrders();

    if (response['status'] == 'success') {
      setState(() {
        orders = response['orders'];
      });
    } else {
      throw Exception('Failed to load orders');
    }
  }

  void _showOrderDetails(BuildContext context, order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order Number: ${order['order_number']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ...order['items'].map<Widget>((item) {
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Quantity: ${item['quantity']}'),
                  trailing: Text('\$${item['price']}', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                );
              }).toList(),
              SizedBox(height: 10),
              ListTile(
                title: Text('Total Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                trailing: Text('\$${order['total'].toStringAsFixed(2)}', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
        ),
        body: ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading:
                SizedBox(
                  child: Image.network(
                    orders[index]['business']['images'] != null  &&
                    orders[index]['business']['images'].isNotEmpty ?
                    orders[index]['business']['images'][0]
                    : 'https://via.placeholder.com/150',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                onTap: () => _showOrderDetails(context, orders[index]),
                title: Text('${orders[index]['business']['business_name']}',
                  style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                subtitle: Text('Status: ${orders[index]['order_status']}'),
                trailing: orders[index]['order_status'] == 'Out for Delivery'
                    ? ElevatedButton(
                        onPressed: () {
                          // navigate to track now screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingPage(
                                orderId: orders[index]['id'],
                                destinationLatitude: 0,
                                destinationLongitude: 0,
                              ),
                            ),
                          );
                        },
                        child: Text('Track Now'),
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}