import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';
import '../../../model/book_model.dart';

Future<BookingResponse> getAllRequests() async {
  final prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('userToken') ?? '';

  var url = Uri.parse(ConstantApi.all_booking_request);

  try {
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return BookingResponse.fromJson(data);
    } else {
      return BookingResponse(
          status: false,
          count: 0,
          bookings: []
      );
    }
  } catch (e) {
    print("Error in getAllRequests: $e");
    return BookingResponse(
        status: false,
        count: 0,
        bookings: []
    );
  }
}