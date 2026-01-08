import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';
import '../notification/sendNotifi.dart';

Future<String> RejectRequests(int bookingId, int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${ConstantApi.reject_booking_request}/$bookingId");

  try {
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Reject Status Code: ${response.statusCode}");
    print("Reject Response Body: ${response.body}");

    var data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {

      await sendNotification(
        userId: userId,
        title: "Booking Rejected",
        message: "عذراً، تم رفض طلب الحجز الخاص بك.",
      );

      return data['message'] ?? "Rejected successfully";

    } else {
      return data['message'] ?? "Failed to reject: ${response.statusCode}";
    }
  } catch (e) {
    print("Error in RejectRequests: $e");
    return "Error occurred: $e";
  }
}