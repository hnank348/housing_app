import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/data/api/authe/update_api.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/itemWidget/text_field.dart';
import 'package:housing_app/model/images.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/auth_model.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final adminFirstNameController = TextEditingController();
  final adminLastNameController = TextEditingController();
  final adminBirthDateController = TextEditingController();
  final adminIdImageController = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    adminFirstNameController.text = widget.user.firstName;
    adminLastNameController.text = widget.user.lastName;
    adminBirthDateController.text = widget.user.birthDate;
    adminIdImageController.text = "Current ID Image";
  }

  Future<void> idImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        Images.idImage = File(pickedFile.path);
        adminIdImageController.text = pickedFile.name;
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
      appBar: AppBar(
        backgroundColor: const Color(0xff2D5C7A),
        title: Text('Edit Profile'.tr(), style: const TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Icon(Icons.person_add_alt, color: Colors.white),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: profImage,
                  child: CircleAvatar(
                    radius: 85,
                    backgroundColor: const Color(0xff2D5C7A),
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: Images.profImage != null
                          ? FileImage(Images.profImage!)
                          : (widget.user.profileImage.isNotEmpty
                          ? NetworkImage(widget.user.profileImage)
                          : const AssetImage('assets/Image/logo sign up.jpg')) as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFieldItem(
                  hinit: 'First Name'.tr(),
                  color: const Color(0xff2D5C7A),
                  hiding: false,
                  icon: const Icon(Icons.person),
                  colorIcon: Colors.white,
                  controller: adminFirstNameController,
                ),
                const SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Last Name'.tr(),
                  color: const Color(0xff2D5C7A),
                  hiding: false,
                  icon: const Icon(Icons.person),
                  colorIcon: Colors.white,
                  controller: adminLastNameController,
                ),
                const SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Birth Date'.tr(),
                  color: const Color(0xff2D5C7A),
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
                    icon: const Icon(Icons.date_range),
                  ),
                  colorIcon: Colors.white,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                TextFieldItem(
                  hinit: 'Id Image'.tr(),
                  color: const Color(0xff2D5C7A),
                  hiding: false,
                  iconButton: IconButton(
                    onPressed: () {
                      idImage();
                    },
                    icon: const Icon(Icons.card_membership),
                  ),
                  colorIcon: Colors.white,
                  controller: adminIdImageController,
                ),
                const SizedBox(height: 20),
                Button(
                  text: 'Save'.tr(),
                  color: const Color(0xff2D5C7A),
                  colorText: Colors.white,
                  onPressed: () async {
                    await update(
                        context,
                        adminFirstNameController.text,
                        adminLastNameController.text,
                        adminBirthDateController.text,
                        Images.profImage,
                        Images.idImage,
                        widget.user.id
                    );
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