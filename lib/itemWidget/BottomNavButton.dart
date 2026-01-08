import 'package:flutter/material.dart';
import 'package:housing_app/model/BottomNavItem.dart';

class BottomNavButton extends StatelessWidget {
  final BottomNavItem item;

  const BottomNavButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Theme.of(context).brightness == Brightness.light
        ? const Color(0xff2D5C7A)
        : Colors.grey;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.id);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            (item.icon as Icon).icon,
            color: item.isActive ? activeColor : Colors.grey[500],
            size: 28,
          ),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: item.isActive ? activeColor : Colors.grey[600],
              fontWeight: item.isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}