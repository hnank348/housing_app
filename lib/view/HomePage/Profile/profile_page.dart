import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/model/images.dart';
import 'package:housing_app/view/HomePage/Profile/booking_requests.dart';
import 'package:housing_app/view/HomePage/Profile/edit_profile.dart';
import 'package:housing_app/view/HomePage/Profile/setting_page.dart';
import 'package:housing_app/view/auth/welcom_page.dart';

import '../../../model/auth_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2D5C7A),
        title: Text('Profile'.tr(), style: const TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(Icons.person_pin, color: Colors.white),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, bottom: 20, left: 50, right: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 105,
                backgroundColor: const Color(0xff2D5C7A),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: user.profileImage.isNotEmpty
                      ? NetworkImage(user.profileImage)
                      : const AssetImage('assets/Image/logo sign up.jpg') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    color: Color(0xff2D5C7A),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PurplePurse',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Booking requests'.tr(),
                color: const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingRequests()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Edit Profile'.tr(),
                color: const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) =>  EditProfile(user: user)),
                  );
                },
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Settings'.tr(),
                color: const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingPage()),
                  );
                },
              ),
              const SizedBox(height: 20),
              Button(
                text: 'Log out'.tr(),
                color: const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm log out'.tr()),
                      content: Text('Are you sure you want to log out?'.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No'.tr()),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes'.tr()),
                        ),
                      ],
                    ),
                  );
                  if (confirm != null && confirm) {
                    Images.idImage = null;
                    Images.profImage = null;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WelcomPage()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}