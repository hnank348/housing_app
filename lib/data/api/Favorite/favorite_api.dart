import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constantApi/constantapi.dart';
import '../../../model/apartment_model.dart';

  Future<List<ApartmentModel>> getMyFavorites() async {
    final String url = "${ConstantApi.baseUrl}/api/favorites";

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        return data
            .map((item) => ApartmentModel.fromJson(item['apartment']))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }

