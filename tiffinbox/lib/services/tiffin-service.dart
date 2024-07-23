import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tiffinbox/models/TiffinIntem.dart';


class TiffinService {
  final String baseUrl = 'http://192.168.56.1:8000/api/';

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

  getAllBusinessTiffins({required String businessId}) async {
    final response = await http.get(
      Uri.parse('${baseUrl}tiffins/business/$businessId'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tiffins');
    }
  }

  addTiffibn(TiffinItem tiffinItem) async {
    // Add tiffin to database 
    final url = Uri.parse('${baseUrl}tiffins/add_tiffin');
    var response = 
    await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(tiffinItem.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add tiffin');
    }
  }

  updateTiffin(TiffinItem tiffinItem) async {
    final url = Uri.parse('${baseUrl}tiffins/update_tiffin');
    var response =
    await http.patch(url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(tiffinItem.toJson()),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update tiffin');
    }
  }

  getAllTiffins() async {
    final response = await http.get(
      Uri.parse('${baseUrl}tiffins'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tiffins');
    }
  }  
}