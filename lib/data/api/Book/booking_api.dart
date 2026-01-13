
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';
import '../../../model/booking_model.dart';

class ApiService {
  static const String _baseUrl = ConstantApi.baseUrl;
  
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    return (token == null || token.isEmpty) ? null : token;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  static Future<Map<String, dynamic>> fetchBookings() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      return {'success': false, 'error': 'Please login again'.tr()};
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/booking'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
print('All my booking::::${response.statusCode}');
      print('All my booking::::${response.body},${response.statusCode}');
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);

        List<Booking> bookings = [];

        if (data is List) {
          bookings = data.map((item) => Booking.fromJson(item)).toList();
        } else if (data is Map<String, dynamic>) {
          if (data.containsKey('bookings')) {
            final List<dynamic> bookingsData = data['bookings'] ?? [];
            bookings = bookingsData.map((item) => Booking.fromJson(item)).toList();
          } else {
            bookings = [Booking.fromJson(data)];
          }
        }

        print('Number of bookings: ${bookings.length}');
        print('Response: ${response.body}');

        return {
          'success': true,
          'bookings': bookings,
        };
      } else {
        print('Error: ${response.body}, Status: ${response.statusCode}');
        return {
          'success': false,
          'error': 'Booking not found: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Exception: $e');
      return {
        'success': false,
        'error': '${'An error occurred'.tr()} $e',
      };
    }
  }

  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found'.tr());
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/booking/cancel/$bookingId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return {
          'success': true,
          'message': 'Booking canceled successfully'.tr(),
        };
      } else if (response.statusCode == 403) {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'You do not have permission to cancel this booking'.tr(),
        };
      } else if (response.statusCode == 404) {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'Booking not found'.tr(),
        };
      } else {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'An error occurred during cancellation'.tr(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Server connection failed check your internet'.tr(),
      };
    }
  }

  static Future<Map<String, dynamic>> updateBooking(
    int bookingId,
    String startDate,
    String endDate,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found'.tr());
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/booking/update/$bookingId')
            .replace(queryParameters: {
          'start_date': startDate,
          'end_date': endDate,
        }),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return {
          'success': true,
          'message': 'Booking updated successfully'.tr(),
        };
      } else {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'Error updating booking'.tr(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Server connection failed check your internet'.tr(),
      };
    }
  }
  static Future<Map<String, dynamic>> submitReview(
      int bookingId,
      int rating,
      String review,
      ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Authentication token not found'.tr());
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/apartments/rate'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'booking_id': bookingId,
          'rating': rating,
          'comment': review,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Response Success: ${response.body}');
        return {
          'success': true,
          'message': responseData['message'] ?? 'The evaluation was successfully submitted'.tr(),
        };
      } else {
        print('Response Error: ${response.body}');
        return {
          'success': false,
          'error': responseData['message'] ?? 'You have already appraised the real state'.tr(),
        };
      }
    } catch (e) {
      print('Catch Error: $e');
      return {
        'success': false,
        'error': 'Server connection failed check your internet'.tr(),
      };
    }
  }}