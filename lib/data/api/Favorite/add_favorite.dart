import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constantApi/constantapi.dart';


Future<String?> toggleFavorite(int apartmentId) async {
  final String url = "${ConstantApi.favorite}";

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('userToken');

  try {
    final response = await http.post(
      Uri.parse(url),
      body: {'apartment_id': apartmentId.toString()},
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response body Favorite: ${response.body}");

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['status'].toString();
    } else {
      print("Error Code: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Exception details: $e");
    return null;
  }
}