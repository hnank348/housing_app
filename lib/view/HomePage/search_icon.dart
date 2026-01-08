import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/itemWidget/button.dart';
import 'package:housing_app/model/apartment_model.dart';
import '../../data/api/HomePage/search_api.dart';

class SearchIcon extends StatefulWidget {
  final Function(List<ApartmentModel>) onSearchComplete;

  const SearchIcon({super.key, required this.onSearchComplete});

  @override
  State<SearchIcon> createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  // الكنترولرز الخاصة بحقول البحث
  final adminRoomController = TextEditingController();
  final adminCityController = TextEditingController();
  final adminAddressController = TextEditingController();
  final adminPriceController = TextEditingController();
  final adminAreaController = TextEditingController();
  final adminGovernorateController = TextEditingController();

  bool _isLoading = false; // متغير لمتابعة حالة البحث

  @override
  void dispose() {
    adminRoomController.dispose();
    adminCityController.dispose();
    adminAddressController.dispose();
    adminPriceController.dispose();
    adminAreaController.dispose();
    adminGovernorateController.dispose();
    super.dispose();
  }

  // دالة تنفيذ البحث
  Future<void> _performSearch() async {
    setState(() => _isLoading = true); // بدء التحميل

    try {
      List<ApartmentModel> results = await searchApartments(
        city: adminCityController.text,
        rooms: adminRoomController.text,
        address: adminAddressController.text,
        price: adminPriceController.text,
        area: adminAreaController.text,
        governorate: adminGovernorateController.text,
      );

      widget.onSearchComplete(results); // إرسال النتائج للواجهة الرئيسية
    } catch (e) {
      debugPrint("Search Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: adminCityController,
              decoration: InputDecoration(
                prefixIcon: _isLoading
                    ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                )
                    : IconButton(
                  onPressed: _performSearch,
                  icon: const Icon(Icons.search),
                ),
                hintText: 'search'.tr(),
                hintStyle: const TextStyle(fontSize: 15),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _showFilterDialog(context),
              icon: const Icon(Icons.tune, color: Colors.blue),
            ),
          )
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20, right: 20, top: 20,
            ),
            child: Column(
              children: [
                Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                const SizedBox(height: 20),
                Text("Search options".tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
                const SizedBox(height: 20),

                _buildFilterField(adminCityController, 'City'.tr(), Icons.location_city),
                _buildFilterField(adminGovernorateController, 'Governorate'.tr(), Icons.map),
                _buildFilterField(adminAddressController, 'address'.tr(), Icons.location_on),
                _buildFilterField(adminRoomController, 'Number rooms'.tr(), Icons.bed, isNumber: true),
                _buildFilterField(adminPriceController, 'Price / month'.tr(), Icons.attach_money, isNumber: true),
                _buildFilterField(adminAreaController, 'Area'.tr(), Icons.square_foot, isNumber: true),

                const SizedBox(height: 30),
                Button(text: "Filtering".tr(), color: Color(0xff2D5C7A), colorText: Colors.white,
                    onPressed: () async {
                         Navigator.pop(context);
                        await _performSearch();
                         },),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}