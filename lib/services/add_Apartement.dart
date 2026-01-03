import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constantApi/constantapi.dart';
import '../model/apartment_model.dart';

class AddApartment {
  Future<ApartmentModel> addApartmentData({
    required String title,
    required String description,
    required String governorate,
    required String city,
    required String address,
    required String rooms,
    required String bathrooms,
    required String area,
    required String pricePerDay,
    required File mainImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Constantapi.apartment),
    );

    request.fields.addAll({
      'title': title,
      'description': description,
      'Governorate': governorate,
      'city': city,
      'address': address,
      'rooms': rooms,
      'bathrooms': bathrooms,
      'area': area,
      'price_per_day': pricePerDay,
    });

    request.files.add(
      await http.MultipartFile.fromPath('image_url', mainImage.path),
    );
    request.headers.addAll({
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Step 1 Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = json.decode(response.body);

      var finalJson =
          responseData['data'] ?? responseData['apartment'] ?? responseData;

      ApartmentModel apartment = ApartmentModel.fromJson(finalJson);

      print("Success! Apartment ID is: ${apartment.id}");

      return apartment;
    } else {
      throw Exception('فشل في إنشاء الشقة: ${response.body}');
    }
  }

  Future<void> addAdditionalImages({
    required int apartmentId,
    required List<File> images,
  }) async {
    if (apartmentId <= 0) {
      print(
        "Error: Apartment ID is invalid ($apartmentId), cannot upload images!",
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('userToken') ?? '';

    var url = "${Constantapi.add_Apatrment_Images}/$apartmentId";
    print("Request URL: $url");

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath('image_url', image.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Step Status: ${response.statusCode}");
      print("Step Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(
          "Success: Images stored successfully for apartment: $apartmentId",
        );
      } else {
        print(
          "Failed to upload images. Server responded with: ${response.body}",
        );
      }
    } catch (e) {
      print("Exception during image upload: $e");
    }
  }
}


