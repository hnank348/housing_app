import 'dart:convert';

import 'package:housing_app/constantApi/constantapi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getApartmentRatings(int apartmentId) async {
  final url = "${ConstantApi.baseUrl}/api/apartments/$apartmentId/ratings";
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken') ?? '';
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('Status Code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Response Body rating: ${response.body}');

      return jsonDecode(response.body);
    } else {
      print('Response Body rating: ${response.body}');
      print('Failed with status: ${response.statusCode}');
    }
  } catch (e) {
    print("Error fetching ratings: $e");
  }
  return {"ratings": [], "average": 0.0};
}