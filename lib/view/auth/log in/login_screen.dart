
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/authe/login_api.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/itemWidget/text_field.dart';

class LoginScreen extends StatelessWidget {
 // const LoginScreen({super.key});
   final adminPasswordController = TextEditingController();
   final adminPhoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90,),
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 200,
                    alignment: Alignment.bottomCenter,
                    child: Image(image: AssetImage('assets/Image/logo log in 1.jpg')),
                  ),
                ),
                SizedBox(height: 50),
                TextFieldItem(
                  hinit: 'Phone Number'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  icon: Icon(Icons.phone),
                  colorIcon: Colors.white,
                  controller: adminPhoneController,
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: 40),
                TextFieldItem(
                  hinit: 'Password'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: true,
                  icon: Icon(Icons.key),
                  colorIcon: Colors.white,
                  controller: adminPasswordController,
                ),
                SizedBox(height: 40),
                Button(
                  text: 'log in'.tr(),
                  color: Color(0xff2D5C7A),
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
