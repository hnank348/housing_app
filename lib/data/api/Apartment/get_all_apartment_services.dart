

import 'package:housing_app/model/apartment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';
import '../../../helper/api.dart';

class AllApartmentService {

  Future<List<ApartmentModel>> getAllApartment() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';
    final response = await Api().get(
      url: ConstantApi.apartment,
      token: token);
    List<dynamic> apartmentsJson = response['apartments'];

    List<ApartmentModel> apartmentsList = [];
    for (int i = 0; i < apartmentsJson.length; i++) {
      apartmentsList.add(
        ApartmentModel.fromJson(apartmentsJson[i]),
      );
    }
    return apartmentsList;
  }
}
