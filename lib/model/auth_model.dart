
import 'package:housing_app/constantApi/constantapi.dart';

class UserResponse {
  final bool status;
  final UserModel? user;

  UserResponse({
    required this.status,
    this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] ?? false,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
class UserModel {
  final int id;
  final int roleId;
  final String firstName;
  final String lastName;
  final String phone;
  final String birthDate;
  final String profileImage;
  final String idImage;
  final String gender;
  final String status;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.roleId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.birthDate,
    required this.profileImage,
    required this.idImage,
    required this.gender,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    String cleanUrl(String? url) {
      if (url == null || url.isEmpty) return '';
      return url.replaceAll(RegExp(r'http://[0-9.]+:8000'), ConstantApi.baseUrl);
    }

    return UserModel(
      id: json['id'] ?? 0,
      roleId: json['role_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      birthDate: json['birth_date'] ?? '',
      profileImage: cleanUrl(json['profile_image']) ,
      idImage: cleanUrl(json['id_image']),
      gender: json['gender'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}