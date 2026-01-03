import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/widgets/BottomNavBar.dart';
import 'package:housing_app/widgets/apartment_pad.dart';

import '../../../data/api/Apartment/favorite_api.dart';

class FavoriteApartment extends StatelessWidget {
  const FavoriteApartment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xff073D5F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Favorite Apartment'.tr(),
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.favorite, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<ApartmentModel>>(
        future: FavoriteService().getMyFavorites(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            List<ApartmentModel> favoriteApartments = snapshot.data!;

            if (favoriteApartments.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 10),
                    Text(
                      'No favorites added yet'.tr(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: favoriteApartments.length,
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: BuildApartmentCard(
                    apartmentModel: favoriteApartments[index],
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}