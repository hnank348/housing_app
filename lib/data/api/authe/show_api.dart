import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:housing_app/model/auth_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';

Future<UserResponse> getUserRequests() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  final url = Uri.parse(ConstantApi.show);

  try {
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Booking Status Code: ${response.statusCode}");

    final Map<String, dynamic> decodedData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserResponse.fromJson(decodedData);
    }
    else if (response.statusCode == 403) {
      throw Exception("Please wait for admin approval to activate your account".tr());
    }
    else {
      String errorMessage = decodedData['message'] ?? "Unknown error occurred";
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  } catch (e) {
    print("Error in getUserRequests: $e");
    rethrow;
  }
}