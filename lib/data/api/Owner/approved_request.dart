
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';

import '../notification/sendNotifi.dart';


Future<String> ApprovedRequests(int bookingId, int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${ConstantApi.approved_booking_request}/$bookingId");

  try {
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      await sendNotification(
          userId: userId,
          title: "Booking Approved",
          message: "تمت الموافقة على طلب الحجز الخاص بك بنجاح"
      );

      return data['message'] ?? "Approved successfully";
    } else {
      return data['message'] ?? "Error: ${response.statusCode}";
    }
  } catch (e) {
    print("Error details: $e");
    return "error";
  }
}

