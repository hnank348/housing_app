import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/api/Apartment/delete_image.dart';
import '../../../../itemWidget/card_item.dart';
import '../../../../itemWidget/images.dart';
import '../../../../itemWidget/text_field_widget.dart';
import '../../../../data/api/Apartment/add_Apartement.dart';
import '../../../../data/api/Apartment/update_apartment.dart';

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
    adminRoomsController = TextEditingController(text: widget.apartment.rooms.toString());
    adminBathroomsController = TextEditingController(text: widget.apartment.bathrooms.toString());
    adminAreaController = TextEditingController(text: widget.apartment.area.toString());
    adminPriceController = TextEditingController(text: widget.apartment.pricePerDay.toString());
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

  Future<void> showDelete() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xff1E1E1E) : Colors.white,
        title: Text('Confirm deletion'.tr(),
            style: TextStyle(color: isDark ? Colors.white : Colors.black)),
        content: Text('Are you sure you want to delete all images?'.tr(),
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr(), style: const TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteAllApartmentImages();
            },
            child: Text('Delete'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAllApartmentImages() async {
    setState(() => isLoading = true);
    int idToDelete = widget.apartment.id;

    bool success = await deleteImage(idToDelete);

    if (mounted) {
      if (success) {
        setState(() {
          widget.apartment.images.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All images deleted successfully").tr(), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete images: you are not the owner").tr(), backgroundColor: Colors.red),
        );
      }
      setState(() => isLoading = false);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Update a real state',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)).tr(),
        backgroundColor: isDark ? Colors.black : const Color(0xff2D5C7A),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title('Real state Images'.tr(), isDark),
                  if (widget.apartment.images.isNotEmpty)
                    TextButton.icon(
                      onPressed: showDelete,
                      icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 20),
                      label: Text('Delete All Images'.tr(), style: const TextStyle(color: Colors.red, fontSize: 13)),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 90,
                child: widget.apartment.images.isEmpty
                    ? Center(child: Text("No images available".tr(), style: const TextStyle(color: Colors.grey)))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.apartment.images.length,
                  itemBuilder: (context, index) {
                    final img = widget.apartment.images[index];
                    return Container(
                      width: 90,
                      height: 90,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(img.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        border: isDark ? Border.all(color: Colors.white12) : null,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 25),
              title('Additional photos (optional)'.tr(), isDark),
              Images(
                multiImages: additionalImages,
                onTap: pickAdditionalImages,
                onRemove: (index) => setState(() => additionalImages.removeAt(index)),
                isMulti: true,
              ),
              SizedBox(height: 25),
              title('Real state details'.tr(), isDark),
              CardItem([
                TextFieldWidget(adminTitleController, 'Real state title'.tr(), Icons.text_fields),
                TextFieldWidget(descController, 'Description'.tr(), Icons.description, maxLines: 3),
              ]),
              SizedBox(height: 20),
              title('Geographic location'.tr(), isDark),
              CardItem([
                Row(children: [
                  Expanded(child: TextFieldWidget(adminGovController, 'Governorate'.tr(), Icons.map)),
                  SizedBox(width: 12),
                  Expanded(child: TextFieldWidget(adminCityController, 'City'.tr(), Icons.location_city)),
                ]),
                TextFieldWidget(adminAddressController, 'The address in detail'.tr(), Icons.location_on),
              ]),
              SizedBox(height: 20),
              title('Area and costs'.tr(), isDark),
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
                color: isDark ? const Color(0xff3e7a9e) : const Color(0xff2D5C7A),
                colorText: Colors.white,
                onPressed: updata,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget title(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black
        ),
      ),
    );
  }
}