import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/services/get_all_product_services.dart';
import 'package:housing_app/widgets/BottomNavBar.dart';
import 'package:housing_app/widgets/EsharScreen.dart';
import 'package:housing_app/widgets/apartment_pad.dart';
import 'package:housing_app/widgets/search_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ApartmentModel> displayedApartments = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      setState(() => isLoading = true);
      List<ApartmentModel> data = await AllApartmentService().getAllApartment();
      setState(() {
        displayedApartments = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void updateApartmentsList(List<ApartmentModel> newList) {
    setState(() {
      displayedApartments = newList;
    });
  }

  Future<bool> _showExitDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'.tr()),
        content: Text('Do you want to exit the application?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr()),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text('Yes'.tr(), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _showExitDialog();
      },
      child: Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        appBar: AppBar(
          backgroundColor: const Color(0xff073D5F),
          elevation: 0,
          title: const Text(
            'Real state for rent',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ).tr(),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Esharscreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: loadInitialData,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(child: Text('Error: $errorMessage'))
            : Column(
          children: [
            SearchIcon(onSearchComplete: updateApartmentsList),
            Expanded(
              child: displayedApartments.isEmpty
                  ? Center(child: const Text('No results found').tr())
                  : ListView.builder(
                itemCount: displayedApartments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: BuildApartmentCard(
                      apartmentModel: displayedApartments[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}