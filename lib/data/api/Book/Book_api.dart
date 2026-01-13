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
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body Book: ${response.body}');

    if (!context.mounted) return;

    if (response.statusCode == 200 || response.statusCode == 201) {
      showDialog1(
        context,
        title: 'Booking successfully'.tr(),
        content: 'The booking request has been successfully submitted! Awaiting approval from the real state owner'.tr(),
        isSuccess: true,
      );
    } else if (response.statusCode == 409) {
      showDialog1(
        context,
        title: 'error'.tr(),
        content: 'This apartment is already booked for the specified dates!'.tr(),
        isSuccess: false,
      );
    } else {
      showDialog1(
        context,
        title: 'error'.tr(),
        content: 'An error occurred during booking. Please try again.'.tr(),
        isSuccess: false,
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    showDialog1(
      context,
      title: 'error'.tr(),
      content: 'The connection to the server failed. Check your internet connection.'.tr(),
      isSuccess: false,
    );
  }
}

void showDialog1(
    BuildContext context, {
      required String title,
      required String content,
      required bool isSuccess,
    }) {
  showDialog(
    context: context,
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      return AlertDialog(
        backgroundColor: Theme.of(ctx).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle_outline : Icons.error_outline,
              color: isSuccess ? Colors.green : Colors.redAccent,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                fontFamily: 'Cairo',
                color: isDark ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                if (isSuccess) {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(ctx);
                }
              },
              child: Text(
                'Ok'.tr(),
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}