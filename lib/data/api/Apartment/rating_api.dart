import 'dart:convert';

import 'package:housing_app/constantApi/constantapi.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getApartmentRatings(int apartmentId) async {
  final url = "${Constantapi.baseUrl}/api/apartments/$apartmentId/ratings";

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(
        response.body,
      );
    }
  } catch (e) {
    print("Error fetching ratings: $e");
  }
  return {"ratings": [], "average": 0.0};
}
