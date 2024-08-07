import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class OrderService {
  String baseUrl = "http://192.168.56.1:8000/api/order";

  Future<dynamic> placeOrder(order) async {
    final response = await http.post(
      Uri.parse("$baseUrl/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(order),
    );

    if (response.statusCode == 200) {
      print('Order placed successfully');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to place order');
    }
  }

  Future<Map<String, dynamic>> getOrders() async {
    var response = await http.get(Uri.parse(
        "$baseUrl/all/${FirebaseAuth.instance.currentUser!.uid}"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get orders');
    }
  }

  Future<Map<String, dynamic>> getBusinessOrders() async {
    var response = await http.get(Uri.parse(
        "$baseUrl/business/${FirebaseAuth.instance.currentUser!.uid}"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get orders');
    }
  }

  Future<Map<String, dynamic>> getOrderAndAddress(int orderId) async {
    var response = await http.get(
        Uri.parse("$baseUrl/$orderId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );
    print("response: $response");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get order');
    }
  }

  updateOrderStatus(int order_number, String order_status) async {
  var response = await http.post(
  Uri.parse("$baseUrl/update/${order_number}"),
  headers: <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode({'order_status': order_status}),
  );
  if (response.statusCode == 200) {
  return json.decode(response.body);
  } else {
  throw Exception('Failed to update order status');
  }
  }

  updateDeliveryPersonDetails(orderid, deliveryBoyLocation) async {
    var body = {
      "deliveryPersonId": FirebaseAuth.instance.currentUser!.uid,
      "deliveryPersonName": FirebaseAuth.instance.currentUser!.displayName,
      "locationLatitude": deliveryBoyLocation.latitude,
      "locationLongitude": deliveryBoyLocation.longitude
    };
    var response = await http.patch(
        Uri.parse("$baseUrl/update/${int.parse(orderid)}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body)
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get order');
    }
  }
}