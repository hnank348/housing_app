import 'package:flutter/material.dart';
import 'package:housing_app/model/BottomNavItem.dart';
import 'package:housing_app/itemWidget/BottomNavButton.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<BottomNavItem> navItems = [
      BottomNavItem(icon: const Icon(Icons.person_outline), label: "Profile", id: '/profile'),
      BottomNavItem(icon: const Icon(Icons.calendar_today), label: "Book", id: '/reserve'),
      BottomNavItem(icon: const Icon(Icons.add_circle), label: 'add', id: '/add'),
      BottomNavItem(icon: const Icon(Icons.favorite_border), label: "Favorite", id: '/favorite'),
      BottomNavItem(icon: const Icon(Icons.home), label: "Home", isActive: true, id: '/home'),
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navItems.map((item) {
          return BottomNavButton(item: item);
        }).toList(),
      ),
    );
  }
}