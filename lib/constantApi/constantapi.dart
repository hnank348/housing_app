
class ConstantApi {
  static const String url="127.0.0.1";
  static const String baseUrl ='http://$url:8000';
  static const String notifications='$baseUrl/api/notifications';
  static const String signup='$baseUrl/api/register';
  static const String login ='$baseUrl/api/login';
  static const String show ='$baseUrl/api/me';
  static const String update ='$baseUrl/api/UserImages';
  static const String apartment ='$baseUrl/api/apartments';
  static const String add_Apatrment='$baseUrl/api/apartments';
  static const String add_Apatrment_Images='$baseUrl/api/apartments/images';
  static const String update_Apatrment='$baseUrl/api/apartments/Update';
  static const String favorite ='$baseUrl/api/favorites/toggle';
  static const String search='$baseUrl/api/apartments/search';
  static const String all_booking_request='$baseUrl/api/owner/index';
  static const String approved_booking_request='$baseUrl/api/owner/approve';
  static const String reject_booking_request='$baseUrl/api/owner/reject';
  static const String delete_booking_request='$baseUrl/api/owner/delete';
  static const String delete_image='$baseUrl/api/apartments/images';



}