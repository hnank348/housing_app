import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/view/HomePage/Apartment/Book.dart';
import 'package:housing_app/view/HomePage/Apartment/update_apartment.dart';
import 'package:housing_app/widgets/location_details.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/api/Apartment/favorite_api.dart';
import '../data/api/Apartment/rating_api.dart';
import '../services/add_Apartement.dart';
import '../services/delete_apartment_api.dart';

class RealEstateApp extends StatefulWidget {
  const RealEstateApp({super.key, required this.apartment});
  final ApartmentModel apartment;

  @override
  State<RealEstateApp> createState() => _RealEstateAppState();
}

class _RealEstateAppState extends State<RealEstateApp> {
  bool favorit = false;
  int currentImageIndex = 0;

  double averageRating = 0.0;
  List<dynamic> ratingsList = [];
  bool isLoadingRatings = true;

  @override
  void initState() {
    super.initState();
    favorit =  false;
    _loadInitialRatings();
  }

  Future<void> _loadInitialRatings() async {
    try {
      final data = await getApartmentRatings(widget.apartment.id);
      if (mounted) {
        setState(() {
          averageRating = (data['average'] as num).toDouble();
          ratingsList = data['ratings'];
          isLoadingRatings = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => isLoadingRatings = false);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm deletion").tr(),
        content: const Text("Are you sure about deleting this apartment?").tr(),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel").tr()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () async {
              Navigator.pop(ctx);
              String serverResponse = await deleteApartment(widget.apartment.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(serverResponse)));
                Navigator.pop(context);
              }
            },
            child: const Text("Delete now").tr(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: DepartementDetails(
                images: widget.apartment.images.map((img) => img.imageUrl).toList(),
                currentIndex: currentImageIndex,
                onPageChanged: (index) => setState(() => currentImageIndex = index),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  String? result = await FavoriteService().toggleFavorite(widget.apartment.id);

                  if (result != null) {
                    setState(() {
                      favorit = (result == "added");
                    });

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result == "added" ? "Added to favorites".tr() : "Removed from favorites".tr()),
                          backgroundColor: result == "added" ? Colors.green : Colors.grey,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("عذراً، فشلت العملية. تأكد من تسجيل الدخول")),
                      );
                    }
                  }
                },
                icon: Icon(Icons.favorite, size: 35, color: favorit ? Colors.red : Colors.white),
              ),
              IconButton(
                onPressed: _confirmDelete,
                icon: const Icon(Icons.delete, size: 35, color: Colors.white70),
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UpdateApartment(apartment: widget.apartment,)),
                  );
                },
                icon: const Icon(Icons.published_with_changes_outlined, size: 35, color: Colors.white70),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeatureSection(
                    title: widget.apartment.title,
                    location: "${widget.apartment.governorate} - ${widget.apartment.city}",
                    rating: averageRating,
                  ),
                  const SizedBox(height: 20),
                  DescriptionHouse(description: widget.apartment.description),
                  const SizedBox(height: 20),
                  BedRooms(
                    bedrooms: widget.apartment.rooms,
                    bathrooms: widget.apartment.bathrooms,
                    area: widget.apartment.area,
                  ),
                  const SizedBox(height: 10),
                  LocationDetails(
                    address: widget.apartment.address,
                    price: widget.apartment.pricePerDay,
                  ),
                  const SizedBox(height: 20),
                  Profile(name: 'Real state office'.tr(), type: 'owner'.tr(), stars: 4),
                  const SizedBox(height: 20),
                  isLoadingRatings
                      ? const Center(child: CircularProgressIndicator())
                      : CommentsSection(
                      ratings: ratingsList,
                      average: averageRating
                  ),
                  const SizedBox(height: 20),
                  Button(
                    text: 'Book Now'.tr(),
                    color: const Color(0xff2D5C7A),
                    colorText: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Book(apartmentId: widget.apartment.id)),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  final String title;
  final String location;
  final double rating;

  const FeatureSection({super.key, required this.title, required this.location, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on, size: 18, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(child: Text(location, style: TextStyle(fontSize: 16, color: Colors.grey[700]))),
            Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
                rating > 0 ? rating.toStringAsFixed(1) : "0.0",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ],
    );
  }
}

class CommentsSection extends StatelessWidget {
  final List<dynamic> ratings;
  final double average;

  const CommentsSection({super.key, required this.ratings, required this.average});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${'Reviews'.tr()} ($average)",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: List.generate(5, (index) => Icon(
                Icons.star,
                color: index < average.floor() ? Colors.amber : Colors.grey[300],
                size: 20,
              )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ratings.isEmpty
            ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: const Text("No reviews yet").tr(),
        )
            : ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ratings.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            var item = ratings[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item['client']['first_name']} ${item['client']['last_name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(item['created_at'].toString().split('T')[0],
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: List.generate(5, (i) => Icon(
                      Icons.star,
                      size: 16,
                      color: i < (item['rating'] as int) ? Colors.amber : Colors.grey[300],
                    )),
                  ),
                  const SizedBox(height: 8),
                  Text(item['comment'] ?? "", style: const TextStyle(color: Colors.black87)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class DescriptionHouse extends StatelessWidget {
  final String description;
  const DescriptionHouse({super.key, required this.description});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description'.tr(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(description, style: const TextStyle(fontSize: 16, height: 1.5)),
      ],
    );
  }
}

class BedRooms extends StatelessWidget {
  final int bedrooms, bathrooms;
  final double area;
  const BedRooms({super.key, required this.bedrooms, required this.bathrooms, required this.area});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildIconInfo(Icons.bed, "${'Rooms'.tr()} $bedrooms")),
        const SizedBox(width: 5),
        Expanded(child: _buildIconInfo(Icons.bathtub, "${'Bathrooms'.tr()} $bathrooms")),
        const SizedBox(width: 5),
        Expanded(child: _buildIconInfo(Icons.square_foot, "$area ${'m²'.tr()}")),
      ],
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class Profile extends StatelessWidget {
  final String name, type;
  final int stars;
  const Profile({super.key, required this.name, required this.type, required this.stars});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const CircleAvatar(radius: 25, child: Icon(Icons.person)),
          const SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent)),
            Text(type, style: const TextStyle(color: Colors.grey)),
          ]),
        ],
      ),
    );
  }
}

class DepartementDetails extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const DepartementDetails({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey,
        child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
      );
    }

    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: onPageChanged,
          itemBuilder: (ctx, index) => Image.network(
            images[index],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.grey[200], child: const Icon(Icons.error)),
          ),
        ),

        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${currentIndex + 1} / ${images.length}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}