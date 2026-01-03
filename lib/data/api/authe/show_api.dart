import 'dart:convert';
import 'package:housing_app/model/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';



Future<UserResponse> getUserRequests() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse(Constantapi.show);

  try {
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Booking Status Code: ${response.statusCode}");
    print("Booking Response Body: ${response.body}");

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return UserResponse.fromJson(data);
    } else {
      throw Exception("Failed to load requests: ${response.statusCode}");
    }
  } catch (e) {
    print("Error in getAllRequests: $e");
    throw Exception("Error occurred: $e");
  }
}
