import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/constantApi/constantapi.dart';
import 'package:housing_app/view/auth/log%20in/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future signUp(
    BuildContext context,
    String gender,
    String firstN,
    String lastN,
    String birthD,
    String phone,
    File prImage,
    String pass,
    File idImage,
    ) async {
  String url = ConstantApi.signup;
  var headers = {'Accept': 'application/json'};
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$url'),
  );

  try {
    request.fields.addAll({
      'gender': gender,
      'first_name': firstN,
      'last_name': lastN,
      'birth_date': birthD,
      'phone': phone,
      'password': pass,
    });

    request.files.add(await http.MultipartFile.fromPath('profile_image', prImage.path));
    request.files.add(await http.MultipartFile.fromPath('id_image', idImage.path));
    request.headers.addAll(headers);

    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      int userId = data['user']['id'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', userId);

      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final isDark = Theme.of(ctx).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: Theme.of(ctx).dialogBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              'Account created'.tr(),
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
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
                const SizedBox(height: 16),
                Text(
                  '${'Account created successfully.'.tr()}\n'
                      '${'Please wait for admin approval to activate your account'.tr()}',
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) =>  LoginScreen()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    'Agreed'.tr(),
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
    } else {
      String errorMessage = 'Registration failed. Please try again.'.tr();
      try {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody.containsKey('error')) errorMessage = jsonBody['error'];
        else if (jsonBody.containsKey('message')) errorMessage = jsonBody['message'];
      } catch (e) {
        errorMessage = '${'error'.tr()}: ${response.statusCode}';
      }

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(ctx).dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Registration Error'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
          content: Text(errorMessage, style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Close'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('error'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
        content: Text(
          'The connection to the server failed. Check your internet connection.'.tr(),
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Ok'.tr(), style: const TextStyle(fontFamily: 'Cairo')),
          ),
        ],
      ),
    );
  }
}