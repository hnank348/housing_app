import 'package:flutter/material.dart';

class BottomNavItem {
  final Icon icon;
  final String label;
  final bool isActive;
  final String id;
  
  BottomNavItem({
    required this.id,
    required this.icon,
    required this.label,
    this.isActive = false,
  });
}
