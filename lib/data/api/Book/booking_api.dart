
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constantApi/constantapi.dart';
import '../../../model/booking_model.dart';

class ApiService {
  static const String _baseUrl = ConstantApi.baseUrl;
  
  // دالة للحصول على التوكن من SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('userToken');
    return (token == null || token.isEmpty) ? null : token;
  }

  // دالة لحفظ التوكن في SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  // دالة لحذف التوكن (لتسجيل الخروج)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  static Future<Map<String, dynamic>> fetchBookings() async {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      return {'success': false, 'error': 'يرجى تسجيل الدخول مجدداً'};
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
        'error': 'حدث خطأ: $e',
      };
    }
  }

  // إلغاء الحجز
  static Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن');
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
          'message': 'تم إلغاء الحجز بنجاح',
        };
      } else if (response.statusCode == 403) {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'ليس لديك صلاحية لإلغاء هذا الحجز',
        };
      } else if (response.statusCode == 404) {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'الحجز غير موجود',
        };
      } else {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'حدث خطأ في الإلغاء',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'تعذر الاتصال بالخادم',
      };
    }
  }

  // تحديث الحجز
  static Future<Map<String, dynamic>> updateBooking(
    int bookingId,
    String startDate,
    String endDate,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن');
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
          'message': 'تم تحديث الحجز بنجاح',
        };
      } else {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'حدث خطأ في تحديث الحجز',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'تعذر الاتصال بالخادم',
      };
    }
  }
// إرسال تقييم
  static Future<Map<String, dynamic>> submitReview(
    int bookingId,
    int rating,
    String review,
  ) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن');
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
          'review': review,
        }),
      );

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return {
          'success': true,
          'message': 'تم إرسال التقييم بنجاح',
        };
      } else {
        print('Response: ${response.body}');
        return {
          'success': false,
          'error': 'حدث خطأ في إرسال التقييم',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'تعذر الاتصال بالخادم',
      };
    }
  }

}