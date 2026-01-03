import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:image_picker/image_picker.dart';
import '../../../itemWidget/card_item.dart';
import '../../../itemWidget/images.dart';
import '../../../itemWidget/text_field_widget.dart';
import '../../../services/add_Apartement.dart';

class AddApartmentPage extends StatefulWidget {
  const AddApartmentPage({super.key});

  @override
  State<AddApartmentPage> createState() => _AddApartmentPageState();
}
class _AddApartmentPageState extends State<AddApartmentPage> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  File? mainImage;
  List<File> additionalImages = [];
  bool isLoading = false;

  final adminTitleController = TextEditingController();
  final descController = TextEditingController();
  final adminGovController = TextEditingController();
  final adminCityController = TextEditingController();
  final adminAddressController = TextEditingController();
  final adminRoomsController = TextEditingController();
  final adminBathroomsController = TextEditingController();
  final adminAreaController = TextEditingController();
  final adminPriceController = TextEditingController();

  @override
  void dispose() {
    adminTitleController.dispose();
    descController.dispose();
    adminGovController.dispose();
    adminCityController.dispose();
    adminAddressController.dispose();
    adminRoomsController.dispose();
    adminBathroomsController.dispose();
    adminAreaController.dispose();
    adminPriceController.dispose();
    super.dispose();
  }

  Future<void> pickMainImage() async {
    final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => mainImage = File(pickedFile.path));
    }
  }

  Future<void> pickAdditionalImages() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        additionalImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> handlePublish() async {
    if (!formKey.currentState!.validate() || mainImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in the data and select the Main photo')),
      );
      return;
    }
    setState(() => isLoading = true);

    try {
      final apartment = await AddApartment().addApartmentData(
        title: adminTitleController.text,
        description: descController.text,
        governorate: adminGovController.text,
        city: adminCityController.text,
        address: adminAddressController.text,
        rooms: adminRoomsController.text,
        bathrooms: adminBathroomsController.text,
        area: adminAreaController.text,
        pricePerDay: adminPriceController.text,
        mainImage: mainImage!,
      );

      if (additionalImages.isNotEmpty && apartment.id != 0) {
        await AddApartment().addAdditionalImages(
          apartmentId: apartment.id,
          images: additionalImages,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully published')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('error: $e')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new real state',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,))
            .tr(),
        backgroundColor: Color(0xff2D5C7A),
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title('Maim photo'.tr()),
              Images(
                mainImage: mainImage,
                onTap: pickMainImage,
                isMulti: false,
              ),
               SizedBox(height: 25),
              Title('Additional photos (optional)'.tr()),
              Images(
                multiImages: additionalImages,
                onTap: pickAdditionalImages,
                onRemove: (index) => setState(() => additionalImages.removeAt(index)),
                isMulti: true,
              ),
               SizedBox(height: 25),
              Title('Real state details'.tr()),
              CardItem([
                TextFieldWidget(adminTitleController, 'Real state title'.tr(),
                    Icons.text_fields),
                TextFieldWidget(
                    descController, 'Description'.tr(), Icons.description,
                    maxLines: 3),
              ]),
               SizedBox(height: 20),
              Title('Geographic location'.tr()),
              CardItem([
                Row(children: [
                  Expanded(child: TextFieldWidget(
                      adminGovController, 'Governorate'.tr(), Icons.map)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(
                      adminCityController, 'City'.tr(), Icons.location_city)),
                ]),
                TextFieldWidget(
                    adminAddressController, 'The address in detail'.tr(),
                    Icons.location_on),
              ]),
               SizedBox(height: 20),
              Title('Area and costs'.tr()),
              CardItem([
                Row(children: [
                  Expanded(child: TextFieldWidget(
                      adminAreaController, 'Area m²'.tr(), Icons.square_foot,
                      isNum: true)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(
                      adminPriceController, 'Price / month'.tr(),
                      Icons.attach_money, isNum: true)),
                ]),
                Row(children: [
                  Expanded(child: TextFieldWidget(
                      adminRoomsController, 'Rooms'.tr(), Icons.bed,
                      isNum: true)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(
                      adminBathroomsController, 'Bathrooms'.tr(),
                      Icons.bathroom, isNum: true)),
                ]),
              ]),
               SizedBox(height: 40),
              Button(text: 'Real state to publish'.tr(), color: Color(0xff2D5C7A),
                  colorText: Colors.white, onPressed:handlePublish),
               SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget Title(String title) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5),
        child: Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      );


}