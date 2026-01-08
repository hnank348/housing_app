import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:housing_app/firebase_options.dart';
import 'package:housing_app/view/HomePage/Apartment/add_Apartement.dart';
import 'package:housing_app/view/HomePage/Favorite/favorite_apartment.dart';
import 'package:housing_app/view/HomePage/Profile/profile_page.dart';
import 'package:housing_app/view/HomePage/booking/booking.dart';
import 'package:housing_app/view/auth/welcom_page.dart';

import 'data/api/authe/show_api.dart';
import 'view/HomePage/home_screen.dart';
import 'model/auth_model.dart';

// 1. تعريف القناة عالية الأهمية
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'هذه القناة مخصصة للإشعارات المنبثقة.',
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    // جلب التوكن
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $token");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // إنشاء القناة
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // تهيئة الإشعارات المحلية (ضرورية جداً لعرض الإشعار)
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // الاستماع للإشعارات
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("تم استلام إشعار الآن!");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: HousingApp(),
    ),
  );
}

class HousingApp extends StatelessWidget {
  HousingApp({super.key});

  static ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff2D5C7A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff2D5C7A),
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xff121111FF),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
          ),
          home: WelcomPage(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/reserve': (context) => MyBookingsScreen(),
            '/add': (context) => const AddApartmentPage(),
            '/favorite': (context) => const FavoriteApartment(),
            '/profile': (context) => FutureBuilder<UserResponse>(
              future: getUserRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.user == null) {
                  return Scaffold(
                    body: Center(child: Text("Error: ${snapshot.error}")),
                  );
                }
                return ProfilePage(user: snapshot.data!.user!);
              },
            ),
          },
        );
      },
    );
  }
}