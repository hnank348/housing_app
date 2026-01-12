import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/authe/signup_api.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/itemWidget/text_field.dart';
import 'package:housing_app/model/images.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final adminPasswordController = TextEditingController();
  final adminPhoneController = TextEditingController();
  final adminFirstNameController = TextEditingController();
  final adminLastNameController = TextEditingController();
  final adminBirthDateController = TextEditingController();
  final adminIdImageController = TextEditingController();

  List<bool> isSelected = [true, false];
  String genderValue = 'male';

  DateTime date=DateTime.now();

  Future<void> idImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        Images.idImage = File(pickedFile.path);
        adminIdImageController.text = pickedFile.name;
        Variables.idImage1 = pickedFile.name;
      });
    }
  }

  Future<void> profImage() async {
    final picker1 = ImagePicker();
    final pickedFile = await picker1.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        Images.profImage = File(pickedFile.path);
      });
    }
  }

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
                SizedBox(height: 20),

                Stack(
                  children: [
                    GestureDetector(
                      onTap: profImage,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: const Color(0xff2D5C7A),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: Images.profImage != null
                              ? FileImage(Images.profImage!)
                              : const AssetImage('assets/Image/logo sign up.jpg') as ImageProvider,
                        ),
                      ),
                    ),
                    // إخفاء الأيقونة إذا تم اختيار صورة، أو تركها دائماً (حسب رغبتك)
                    // هنا قمت بوضعها لتظهر في الزاوية اليمنى السفلية
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color(0xff2D5C7A), // لون خلفية الأيقونة
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFieldItem(
                  hinit: 'First Name'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  icon: Icon(Icons.person),
                  colorIcon: Colors.white,
                  controller: adminFirstNameController,
                ),
                SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Last Name'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  icon: Icon(Icons.person),
                  colorIcon: Colors.white,
                  controller: adminLastNameController,
                ),
                SizedBox(height: 10),

                TextFieldItem(
                  hinit: 'Birth Date'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  controller: adminBirthDateController,
                  iconButton: IconButton(
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        initialDate: date,
                      );

                      if (newDate == null) return;

                      setState(() {
                        date = newDate;

                        String formattedDate =
                            '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';

                        adminBirthDateController.text = formattedDate;
                      });
                    },
                    icon: Icon(Icons.date_range),
                  ),
                  colorIcon: Colors.white,
                ),

                SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Phone Number'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  icon: Icon(Icons.phone),
                  colorIcon: Colors.white,
                  controller: adminPhoneController,
                  textInputType: TextInputType.number,
                ),
                // SizedBox(height: 10),
                // TextFieldItem(
                //   hinit: 'Confirm Phone Number'.tr(),
                //   color: Color(0xff2D5C7A),
                //   hiding: false,
                //   icon: Icon(Icons.phone),
                //   colorIcon: Colors.white,
                //   controller: adminConfirmPhoneController,
                //   textInputType: TextInputType.number,
                // ),
                SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Password'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: true,
                  icon: Icon(Icons.key),
                  colorIcon: Colors.white,
                  controller: adminPasswordController,
                ),
                SizedBox(height: 10),

                TextFieldItem(
                  hinit: 'Id Image'.tr(),
                  color: Color(0xff2D5C7A),
                  hiding: false,
                  controller: adminIdImageController,
                  iconButton: IconButton(
                    onPressed: () {
                      setState(() {
                        idImage();
                      });
                    },
                    icon: Icon(Icons.card_membership),
                  ),
                  colorIcon: Colors.white,
                ),
                SizedBox(height: 10),

                SizedBox(
                  height: 50,

                  child: ToggleButtons(
                    verticalDirection: VerticalDirection.down,

                    color: Color(0xff2D5C7A),
                    borderColor: Color(0xff2D5C7A),
                    fillColor: Color.fromARGB(255, 70, 142, 186),
                    borderRadius: BorderRadius.circular(10),
                    isSelected: isSelected,
                    onPressed: (index) {
                      setState(() {
                        for (int i = 0; i < isSelected.length; i++) {
                          isSelected[i] = i == index;
                        }

                        if (index == 0) {
                          genderValue = 'male';
                        } else {
                          genderValue = 'female';
                        }
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "          Male         ".tr(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "         Female         ".tr(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                Button(
                  text: 'Sign Up'.tr(),
                  color: Color(0xff2D5C7A),
                  colorText: Colors.white,
                  onPressed: ()async {

                    await signUp(
                      context,
                      genderValue,
                      adminFirstNameController.text,
                      adminLastNameController.text,
                      adminBirthDateController.text,
                      adminPhoneController.text,
                      Images.profImage!,
                      adminPasswordController.text,
                      Images.idImage!,
                    );
                    Variables.firstName = adminFirstNameController.text;
                    Variables.lastName = adminLastNameController.text;
                    Variables.birthDate = adminBirthDateController.text;
                    Variables.phone = adminPhoneController.text;
                    Variables.password = adminPasswordController.text;
                    Variables.idImage1 = adminIdImageController.text;
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