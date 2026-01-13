import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/authe/login_api.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/itemWidget/text_field.dart';

class LoginScreen extends StatelessWidget {
  final adminPasswordController = TextEditingController();
  final adminPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90,),
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 200,
                    alignment: Alignment.bottomCenter,
                    child: isDark ? const Image(image: AssetImage('assets/Image/logo log in 2.jpg'))
                        :const Image(image: AssetImage('assets/Image/logo log in 1.jpg')),
                  ),
                ),
                const SizedBox(height: 50),
                TextFieldItem(
                  hinit: 'Phone Number'.tr(),
                  color: isDark ? const Color(0xff3e7a9e) : const Color(0xff2D5C7A),
                  hiding: false,
                  icon: const Icon(Icons.phone),
                  colorIcon: Colors.white,
                  controller: adminPhoneController,
                  textInputType: TextInputType.number,
                ),
                const SizedBox(height: 40),
                TextFieldItem(
                  hinit: 'Password'.tr(),
                  color: isDark ? const Color(0xff3e7a9e) : const Color(0xff2D5C7A),
                  hiding: true,
                  icon: const Icon(Icons.key),
                  colorIcon: Colors.white,
                  controller: adminPasswordController,
                ),
                const SizedBox(height: 40),
                Button(
                  text: 'log in'.tr(),
                  color: isDark ? const Color(0xff3e7a9e) : const Color(0xff2D5C7A),
                  colorText: Colors.white,
                  onPressed: () {
                    login(context, adminPhoneController.text, adminPasswordController.text);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}