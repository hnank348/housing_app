import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constantApi/constantapi.dart';

Future update(BuildContext context, String? firstN, String? lastN, String? birthD,
    File? prImage, File? idImage, int id) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken') ?? '';

  var url = Uri.parse("${ConstantApi.update}/$id");

  var request = http.MultipartRequest("POST", url);

  request.headers.addAll({
    "Accept": "application/json",
    'Authorization': 'Bearer $token'
  });

  if (firstN != null && firstN.isNotEmpty) {
    request.fields['first_name'] = firstN;
  }
  if (lastN != null && lastN.isNotEmpty) {
    request.fields['last_name'] = lastN;
  }
  if (birthD != null && birthD.isNotEmpty) {
    request.fields['birth_date'] = birthD;
  }

  if (prImage != null) {
    request.files.add(await http.MultipartFile.fromPath('profile_image', prImage.path));
  }

  if (idImage != null) {
    request.files.add(await http.MultipartFile.fromPath('id_image', idImage.path));
  }

  try {
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Profile updated successfully: $data");

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Success").tr(),
            content: const Text("Your profile has been updated successfully.").tr(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("OK").tr(),
              ),
            ],
          ),
        );
      }
    } else {
      print("Status Code: ${response.statusCode} - ${response.body}");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to update: ${response.statusCode}"))
        );
      }
    }
  } catch (e) {
    print("Exception: $e");
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("An error occurred: $e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }
}