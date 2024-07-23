import 'package:fbroadcast/fbroadcast.dart';
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

  void _fetchOrders() async {
    var response  = await OrderService().getOrders();

    if (response['status'] == 'success') {
      setState(() {
        orders = response['orders'];
      });
    } else {
      throw Exception('Failed to load orders');
    }
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
          return ListTile(

            title: Text(orders[index]['order_number'].toString()),
            subtitle: Text(orders[index]['order_status']),
            // show a track now button if order is currently in progress
            trailing: orders[index]['order_status'] == 'Out for Delievery'
                ? ElevatedButton(
                    onPressed: () {
                      // navigate to track now screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderTrackingPage(
                          orderId: orders[index]['id'],
                          destinationLatitude: 0,
                          destinationLongitude: 0
                          )),
                      );
                      
                    },
                    child: Text('Track Now'),
                  )
                : null            
          );
        },
      ),
    ),
    );
  }
}