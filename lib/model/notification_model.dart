import 'auth_model.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final int isRead;
  final String createdAt;
  final UserModel? user;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.user,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] ?? 0,
      createdAt: json['created_at'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}