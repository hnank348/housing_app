import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:housing_app/constantApi/constantapi.dart';
import '../notification/sendNotifi.dart';

Future<String> DeleteRequests(int bookingId, int userId) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${ConstantApi.delete_booking_request}/$bookingId");

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

      // 2. استدعاء دالة إرسال الإشعار عند نجاح الحذف
      sendNotification(
        userId: userId,
        title: "Booking Rejected",
        message: "عذراً، تم رفض طلب الحجز الخاص بك.",
      );

      return data['message'] ?? "Deleted successfully";
    } else {
      return data['message'] ?? "Failed to delete: ${response.statusCode}";
    }
  } catch (e) {
    print("Error in DeleteRequests: $e");
    return "Error occurred: $e";
  }
}