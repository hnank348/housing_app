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
          builder: (ctx) {
            final isDark = Theme.of(ctx).brightness == Brightness.dark;
            return AlertDialog(
              backgroundColor: Theme.of(ctx).dialogBackgroundColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Success".tr(),
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
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Your profile has been updated successfully.".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                      Navigator.pop(ctx);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK".tr(),
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
    } else {
      print("Status Code: ${response.statusCode} - ${response.body}");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${"Failed to update".tr()}: ${response.statusCode}"),
              backgroundColor: Colors.redAccent,
            )
        );
      }
    }
  } catch (e) {
    print("Exception: $e");
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(ctx).dialogBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Error".tr(), style: const TextStyle(fontFamily: 'Cairo')),
          content: Text("${"An error occurred".tr()}: $e", style: const TextStyle(fontFamily: 'Cairo')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Close".tr(), style: const TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      );
    }
  }
}