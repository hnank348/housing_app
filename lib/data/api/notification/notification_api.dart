import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constantApi/constantapi.dart';
import '../../../model/notification_model.dart';

Future<List<NotificationModel>> getNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse(ConstantApi.notifications);

  try {
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Notifications Status Code: ${response.statusCode}");
    print("Notifications Response Body: ${response.body}");

    if (response.statusCode == 200) {
     List<dynamic> data = jsonDecode(response.body);

      return data.map((json) => NotificationModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications: ${response.statusCode}");
    }
  } catch (e) {
    print("Error in getNotifications: $e");
    throw Exception("Error occurred: $e");
  }
}