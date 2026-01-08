// import 'dart:convert';
// import 'package:housing_app/constantApi/constantapi.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// Future<void> searchApartments({
//   String? city,
//   String? address,
//   String? price,
//   String? rooms,
//   String? area,
// }) async {
//   final String url = Constantapi.search;
//
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('userToken') ?? '';
//
//   Map<String, dynamic> bodyData = {};
//   if (city != null && city.isNotEmpty) bodyData['city'] = city;
//   if (address != null && address.isNotEmpty) bodyData['address'] = address;
//   if (price != null && price.isNotEmpty) bodyData['price_per_day'] = price;
//   if (rooms != null && rooms.isNotEmpty) bodyData['rooms'] = rooms;
//   if (area != null && area.isNotEmpty) bodyData['area'] = area;
//
//   var headers = {
//     'Accept': 'application/json',
//     'Content-Type': 'application/json', // ضروري جداً عند إرسال Body
//     'Authorization': 'Bearer $token',
//   };
//
//   try {
//     var response = await http.post(
//       Uri.parse(url),
//       headers: headers,
//       body: jsonEncode(bodyData),
//     );
//
//     if (response.statusCode == 200) {
//       String responseData = utf8.decode(response.bodyBytes);
//       print("تمت الفلترة بنجاح: $responseData");
//
//     } else {
//       print("خطأ من السيرفر: ${response.statusCode} - ${response.body}");
//     }
//   } catch (e) {
//     print("حدث خطأ في الاتصال: $e");
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/constantApi/constantapi.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ApartmentModel>> searchApartments({
  String? city,
  String? address,
  String? price,
  String? rooms,
  String? area,
  String? governorate,
}) async {
  final String url = ConstantApi.search;
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken') ?? '';

  Map<String, dynamic> bodyData = {};
  if (city != null && city.isNotEmpty) bodyData['city'] = city;
  if (address != null && address.isNotEmpty) bodyData['address'] = address;
  if (price != null && price.isNotEmpty) bodyData['price_per_day'] = price;
  if (rooms != null && rooms.isNotEmpty) bodyData['rooms'] = rooms;
  if (area != null && area.isNotEmpty) bodyData['area'] = area;

  if (governorate != null && governorate.isNotEmpty) {
    bodyData['Governorate'] = governorate;
  }

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(bodyData),
    );

    if (response.statusCode == 200) {
      String responseData = utf8.decode(response.bodyBytes);
      var map = jsonDecode(responseData);

      List<dynamic> apartmentsJson = map['apartments'];
      return apartmentsJson
          .map((json) => ApartmentModel.fromJson(json))
          .toList();
    } else {
      print("Error: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    print("Connection Error: $e");
    return [];
  }
}
