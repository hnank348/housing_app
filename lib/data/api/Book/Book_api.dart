import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';

Future<void> bookApi(
  BuildContext context,
  String startDate,
  String endDate,
  int apartmentId,
) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    String url = ConstantApi.baseUrl;

    var response = await http.post(
      Uri.parse('$url/api/booking/create'),
      body: {
        'start_date': startDate,
        'end_date': endDate,
        'apartment_id': apartmentId.toString(),
      },
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body Book: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      var js = jsonDecode(response.body);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Booking successfully').tr(),
          content: Text(
            'The booking request has been successfully submitted! Awaiting approval from the real state owner',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Ok').tr(),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 409) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('error').tr(),
          content: Text('This apartment is already booked for the specified dates!').tr(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok').tr(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('error').tr(),
          content: Text('An error occurred during booking. Please try again.').tr(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok').tr(),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print('An error occurred: $e');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('error').tr(),
        content: Text('The connection to the server failed. Check your internet connection.').tr(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok').tr(),
          ),
        ],
      ),
    );
  }
}
