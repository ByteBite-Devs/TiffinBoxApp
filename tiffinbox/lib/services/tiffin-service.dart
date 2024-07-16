import 'package:http/http.dart' as http;
import 'dart:convert';


class TiffinService {
  final String baseUrl = 'http://192.168.84.39:8000/api/';

  Future<Map<String, dynamic>> getBusinessDetails(String id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}business/${id}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load business details');
    }
  }

  Future<Map<String, dynamic>> getTiffinDetails(String id) async {
    final response = await http.get(
      Uri.parse('${baseUrl}tiffin/${id}'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tiffin details');
    }
  }

}