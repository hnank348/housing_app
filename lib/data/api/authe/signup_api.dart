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
 String url=Constantapi.signup;
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
    request.files.add(
      await http.MultipartFile.fromPath('id_image', idImage.path),
    );
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

      print("User ID saved: $userId");
      showDialog (
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('Account created').tr(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return LoginScreen();}));
              },
              child: Text('Agreed').tr(),
            ),
          ],
          content: Column(
            children: [
              Text(
                'Your request has been successfully submitted.'.tr()),
              Text('Please wait for admin approval to activate your account'.tr(),),
            ],
          ),
        ),


      );
    } else {
      print('sorry ${response.statusCode}');

      String errorMessage = 'Registration failed. Please try again.';
      try {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody.containsKey('error') && jsonBody['error'] is String) {
          errorMessage = jsonBody['error'];
        } else if (jsonBody.containsKey('message') && jsonBody['message'] is String) {
          errorMessage = jsonBody['message'];
        }
      } catch (e) {
        print('Error parsing response body: $e');
        errorMessage = 'Registration failed with status code ${response.statusCode}';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Registration Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
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