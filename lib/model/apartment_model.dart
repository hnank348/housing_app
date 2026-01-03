
import 'package:housing_app/constantApi/constantapi.dart';

class ApartmentModel {
  final int id;
  final int ownerId;
  final String title;
  final String description;
  final String city;
  final String address;
  final double pricePerDay;
  final int rooms;
  final int bathrooms;
  final double area;
  final String governorate;
  final DateTime createdAt;
  final List<ApartmentImage> images;

  ApartmentModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.city,
    required this.address,
    required this.pricePerDay,
    required this.rooms,
    required this.bathrooms,
    required this.area,
    required this.governorate,
    required this.createdAt,
    required this.images,
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic value) => int.tryParse(value?.toString() ?? '0') ?? 0;
    double toDouble(dynamic value) => double.tryParse(value?.toString() ?? '0.0') ?? 0.0;

    return ApartmentModel(
      id: toInt(json['id'] ?? json['apartment_id']),
      ownerId: toInt(json['owner_id']),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      pricePerDay: toDouble(json['price_per_day']),
      rooms: toInt(json['rooms']),
      bathrooms: toInt(json['bathrooms']),
      area: toDouble(json['area']),
      governorate: (json['Governorate'] ?? json['governorate'])?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      images: json['images'] != null && json['images'] is List
          ? (json['images'] as List).map((img) => ApartmentImage.fromJson(img)).toList()
          : [],
    );
  }
}

class ApartmentImage {
  final int id;
  final int apartmentId;
  final String imageUrl;

  ApartmentImage({
    required this.id,
    required this.apartmentId,
    required this.imageUrl,
  });

  factory ApartmentImage.fromJson(Map<String, dynamic> json) {
    String rawUrl = json['image_url']?.toString() ?? '';
    String currentIp = Constantapi.url;

    String fixedUrl = rawUrl.replaceAll(RegExp(r'http://[0-9.]+:8000'), 'http://$currentIp:8000');

 if (fixedUrl.contains("/storage/")) {
      fixedUrl = fixedUrl.replaceFirst("/storage/", "/");
    }

    fixedUrl = fixedUrl.replaceAll(":8000//", ":8000/");

    return ApartmentImage(
      id: int.tryParse(json['id'].toString()) ?? 0,
      apartmentId: int.tryParse(json['apartment_id'].toString()) ?? 0,
      imageUrl: fixedUrl,
    );
  }}