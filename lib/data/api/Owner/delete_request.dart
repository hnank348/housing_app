import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';

Future<String> DeleteRequests(int bookingId) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${Constantapi.delete_booking_request}/$bookingId");

  try {
    var response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Booking Status Code: ${response.statusCode}");
    print("Booking Response Body: ${response.body}");

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['message'] ?? "Deleted successfully";
    } else {
      return data['message'] ??"Failed to load requests: ${response.statusCode},${response.body}";
    }
  } catch (e) {
    print("Error in getAllRequests: $e");
    throw Exception("Error occurred: $e");
  }
}
