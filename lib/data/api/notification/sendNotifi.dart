import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';

Future<bool> sendNotification({
  required int userId,
  required String title,
  required String message,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${ConstantApi.notifications}/create");

  try {
    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId.toString(),
        'title': title,
        'message': message,
      }),
    );

    print("Create Notification Status: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print("Error in sendNotification: $e");
    return false;
  }
}