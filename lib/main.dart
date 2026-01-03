import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:housing_app/view/HomePage/Apartment/add_Apartement.dart';
import 'package:housing_app/view/HomePage/Favorite/favorite_apartment.dart';
import 'package:housing_app/view/HomePage/Profile/profile_page.dart';
import 'package:housing_app/view/auth/welcom_page.dart';
import 'package:housing_app/widgets/Add_Apartment.dart';

import 'data/api/authe/show_api.dart';
import 'home_screen.dart';
import 'model/auth_model.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
   EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child:   HousingApp(),
   ),
  );
}

// ignore: must_be_immutable
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
// Light theme
          theme: ThemeData(
            useMaterial3: true, 
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff2D5C7A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),

            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff2D5C7A),
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

// Dark theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xff121111FF),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xff2D5C7A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white),
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),

            colorScheme: const ColorScheme.dark(
              primary: Color(0xff2D5C7A),
              surface: Colors.black,
            ),
          ),
      home:  WelcomPage(),
          routes: {
            '/home': (context) => HomeScreen(),
            // '/profile' :(context) => ,
            // '/reserve' :(context) => ResivesMe(),
            '/add' : (context) => AddApartmentPage(),
            '/favorite' :(context) =>FavoriteApartment(),
            '/profile': (context) => FutureBuilder<UserResponse>(
              future: getUserRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasError || !snapshot.hasData || snapshot.data!.user == null) {
                  return Scaffold(
                    body: Center(child: Text("Error loading profile: ${snapshot.error}")),
                  );
                }
                return ProfilePage(user: snapshot.data!.user!);
              },
            ),
            // '/apaDeta':(context) =>RealEstateApp(),
          },
    );
      },
    );
  }
}