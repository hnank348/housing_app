import 'package:flutter/material.dart';
import 'package:housing_app/model/BottomNavItem.dart';

class BottomNavButton extends StatelessWidget {
  final BottomNavItem item;

  const BottomNavButton({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeColor = isDark
        ? const Color(0xff4690bd)
        : const Color(0xff2D5C7A);

    final Color inactiveColor = isDark
        ? Colors.grey[500]!
        : Colors.grey[600]!;

    return GestureDetector(
      onTap: () {
        if (!item.isActive) {
          Navigator.pushNamed(context, item.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              (item.icon).icon,
              color: item.isActive ? activeColor : inactiveColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                color: item.isActive ? activeColor : inactiveColor,
                fontWeight: item.isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (item.isActive)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 15,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}