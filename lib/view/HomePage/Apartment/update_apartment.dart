import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../../itemWidget/card_item.dart';
import '../../../itemWidget/images.dart';
import '../../../itemWidget/text_field_widget.dart';
import '../../../services/add_Apartement.dart';
import '../../../services/delete_image.dart';
import '../../../services/update_product.dart';

class UpdateApartment extends StatefulWidget {
  final ApartmentModel apartment;
  const UpdateApartment({super.key, required this.apartment});

  @override
  State<UpdateApartment> createState() => _UpdateApartmentState();
}

class _UpdateApartmentState extends State<UpdateApartment> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  List<File> additionalImages = [];
  bool isLoading = false;

  late TextEditingController adminTitleController;
  late TextEditingController descController;
  late TextEditingController adminGovController;
  late TextEditingController adminCityController;
  late TextEditingController adminAddressController;
  late TextEditingController adminRoomsController;
  late TextEditingController adminBathroomsController;
  late TextEditingController adminAreaController;
  late TextEditingController adminPriceController;

  @override
  void initState() {
    super.initState();
    adminTitleController = TextEditingController(text: widget.apartment.title);
    descController = TextEditingController(text: widget.apartment.description);
    adminGovController = TextEditingController(text: widget.apartment.governorate);
    adminCityController = TextEditingController(text: widget.apartment.city);
    adminAddressController = TextEditingController(text: widget.apartment.address);
    adminRoomsController = TextEditingController(text: widget.apartment.rooms?.toString());
    adminBathroomsController = TextEditingController(text: widget.apartment.bathrooms?.toString());
    adminAreaController = TextEditingController(text: widget.apartment.area?.toString());
    adminPriceController = TextEditingController(text: widget.apartment.pricePerDay?.toString());
  }

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

  Future<void> pickAdditionalImages() async {
    final List<XFile> pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        additionalImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> updata() async {
    if (formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await UpdateProduct().updateApartmentData(
          apartmentId: widget.apartment.id,
          title: adminTitleController.text,
          description: descController.text,
          governorate: adminGovController.text,
          city: adminCityController.text,
          address: adminAddressController.text,
          rooms: adminRoomsController.text,
          bathrooms: adminBathroomsController.text,
          area: adminAreaController.text,
          pricePerDay: adminPriceController.text,
        );

        if (additionalImages.isNotEmpty) {
          await AddApartment().addAdditionalImages(
            apartmentId: widget.apartment.id,
            images: additionalImages,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Successfully updated').tr(),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: you are not the owner').tr(), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update a real state',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)).tr(),
        backgroundColor: const Color(0xff2D5C7A),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
              titleSection('Real state Images'.tr()),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.apartment.images.length,
                  itemBuilder: (context, index) {
                    final img = widget.apartment.images[index];
                    return Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(img.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 12,
                          child: InkWell(
                            onTap: () async {
                              int idToDelete = widget.apartment.id;

                              bool success = await deleteImage(idToDelete);

                              if (success) {

                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Image deleted successfully").tr(), backgroundColor: Colors.green),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(content: Text("Failed to delete image: you are not the owner").tr(), backgroundColor: Colors.red),
                                );
                              }
                            },
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 12, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 25),
              titleSection('Additional photos (optional)'.tr()),
              Images(
                multiImages: additionalImages,
                onTap: pickAdditionalImages,
                onRemove: (index) => setState(() => additionalImages.removeAt(index)),
                isMulti: true,
              ),
               SizedBox(height: 25),
              titleSection('Real state details'.tr()),
              CardItem([
                TextFieldWidget(adminTitleController, 'Real state title'.tr(), Icons.text_fields),
                TextFieldWidget(descController, 'Description'.tr(), Icons.description, maxLines: 3),
              ]),
               SizedBox(height: 20),
              titleSection('Geographic location'.tr()),
              CardItem([
                Row(children: [
                  Expanded(child: TextFieldWidget(adminGovController, 'Governorate'.tr(), Icons.map)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(adminCityController, 'City'.tr(), Icons.location_city)),
                ]),
                TextFieldWidget(adminAddressController, 'The address in detail'.tr(), Icons.location_on),
              ]),
               SizedBox(height: 20),
              titleSection('Area and costs'.tr()),
              CardItem([
                Row(children: [
                  Expanded(child: TextFieldWidget(adminAreaController, 'Area m²'.tr(), Icons.square_foot, isNum: true)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(adminPriceController, 'Price / month'.tr(), Icons.attach_money, isNum: true)),
                ]),
                Row(children: [
                  Expanded(child: TextFieldWidget(adminRoomsController, 'Rooms'.tr(), Icons.bed, isNum: true)),
                   SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(adminBathroomsController, 'Bathrooms'.tr(), Icons.bathroom, isNum: true)),
                ]),
              ]),
               SizedBox(height: 40),
              Button(
                text: 'Save'.tr(),
                color: const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: updata,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}