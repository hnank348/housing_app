import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';

Future<String> deleteApartment(int apartmentId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('userToken') ?? '';

  final url = Uri.parse("${ConstantApi.apartment}/Delete/$apartmentId");
  try {
    final response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print("Deleted successfully");
      return "Apartment deleted successfully";

    }  else if (response.statusCode == 404){
      print("Delete failed:${response.body}");
      return 'Apartment not found'.tr();
    }
    else{
      print("Delete failed:${response.body}");
      return 'Error: you are not the owner'.tr();
    }
  } catch (e) {
    print("Error during delete: $e");
    return 'Sorry';
  }
}
