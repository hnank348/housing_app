import 'package:flutter/material.dart';
import 'package:housing_app/BottomNavItem.dart';
import 'package:housing_app/widgets/BottomNavButton.dart';


class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BottomNavItem> navItems = [
      BottomNavItem(icon: Icon(Icons.person_outline), label: "Profile",id: '/profile'),
      BottomNavItem(icon: Icon(Icons.explore), label: "Explore",id: '/reserve'),
      BottomNavItem(icon: Icon(Icons.add_circle), label: 'add',id: '/add'),
      BottomNavItem(icon: Icon(Icons.favorite_border), label: "Favorite",id: '/favorite'),
      BottomNavItem(icon: Icon(Icons.home), label: "Home", isActive: true,id: '/home'),
      // BottomNavItem(id: 'id', icon, label: label)
    ];

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
