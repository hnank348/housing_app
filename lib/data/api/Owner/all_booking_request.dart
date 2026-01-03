import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';

import '../../../model/book_model.dart';


  Future<BookingResponse> getAllRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('userToken') ?? '';

    var url = Uri.parse(Constantapi.all_booking_request);

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

        return BookingResponse.fromJson(data);
      } else {
        throw Exception("Failed to load requests: ${response.body}");
      }
    } catch (e) {
      print("Error in getAllRequests: $e");
      throw Exception("Error occurred: $e");
    }
  }
