import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constantApi/constantapi.dart';

Future login(BuildContext context, String mobil, String pass) async {
  try {
    String url = Constantapi.login;
    var response = await http.post(
      Uri.parse('$url'),
      body: {
        'phone': mobil,
        'password': pass,
      },
    );

    if (response.statusCode == 200) {
      var js = jsonDecode(response.body);

      print("Full Server Response: $js");

      String? token = js['token'];

      var userData = js['admin'] ?? js['client'];

      if (userData != null) {
        String currentStatus = userData['status'].toString().trim().toLowerCase();

        print("Detected Status: '$currentStatus'");

        if (currentStatus != 'approved') {
          _showErrorDialog(context, 'حسابك بانتظار موافقة الإدارة');
          return;
        }
      } else {
        print("Error: Could not find user/client object in response");
      }

      final prefs = await SharedPreferences.getInstance();
      if (token != null) await prefs.setString('userToken', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else if (response.statusCode == 401) {
      _showErrorDialog(context, 'Incorrect phone number or password'.tr());
    } else {
      print('Error ${response.statusCode}');
    }

  } catch (e) {
    print('An error occurred: $e');
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('error').tr(),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok').tr()),
      ],
    ),
  );
}