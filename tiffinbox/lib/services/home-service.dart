import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeServie {
  String baseUrl = 'http://192.168.84.39:8000/api/';

  Future<Map<String, dynamic>> getData() async {
    final response = await http.get(
      Uri.parse('${baseUrl}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}