import 'dart:async';
import 'dart:convert';
import 'package:housing_app/constantApi/constantapi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:housing_app/model/apartment_model.dart';
import 'package:housing_app/data/api/Apartment/get_all_apartment_services.dart';
import 'package:housing_app/itemWidget/BottomNavBar.dart';
import 'package:housing_app/view/HomePage/Notification.dart';
import 'package:housing_app/view/HomePage/Apartment/apartment_list.dart';
import 'package:housing_app/view/HomePage/search_icon.dart';
import 'package:housing_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ApartmentModel> displayedApartments = [];
  bool isLoading = true;
  String? errorMessage;

  Timer? _notificationTimer;
  int _lastNotificationId = 0;

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    loadInitialData();
    _startLocalNotificationPolling();
  }

  void _startLocalNotificationPolling() {
    _notificationTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _checkNewNotifications();
    });
  }

  Future<void> _checkNewNotifications() async {
    final url = "${ConstantApi.notifications}";
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          var latestNotif = data.first;
          int currentId = latestNotif['id'];

          if (_lastNotificationId == 0 || currentId > _lastNotificationId) {

            _lastNotificationId = currentId;

            _showPopup(latestNotif['title'], latestNotif['message']);
          }
        }
      }
    } catch (e) {
      debugPrint("Notification Polling Error: $e");
    }
  }

  void _showPopup(String? title, String? body) {
    print("محاولة إظهار الإشعار على الشاشة الآن...");

    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecond,
      title ?? "تنبيه جديد",
      body ?? "لديك رسالة جديدة من النظام",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'Default Channel',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
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
          backgroundColor: const Color(0xff2D5C7A),
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