
import 'dart:convert';

import 'package:housing_app/model/apartment_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constantApi/constantapi.dart';

class UpdateProduct {
  Future<ApartmentModel> updateApartmentData({
    required int apartmentId,
    String? title,
    String? description,
    String? governorate,
    String? city,
    String? address,
    String? rooms,
    String? bathrooms,
    String? area,
    String? pricePerDay,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    var url = Uri.parse("${Constantapi.update_Apatrment}/$apartmentId").replace(
      queryParameters: {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (governorate != null) 'Governorate': governorate,
        if (city != null) 'city': city,
        if (address != null) 'address': address,
        if (rooms != null) 'rooms': rooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (area != null) 'area': area,
        if (pricePerDay != null) 'price_per_day': pricePerDay,
      },
    );

    var response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Update Response: ${response.body}");

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var finalJson = responseData['apartment'] ?? responseData;
      return ApartmentModel.fromJson(finalJson);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }
}