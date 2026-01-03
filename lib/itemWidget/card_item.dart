import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  // جعلنا الـ children بارامتر أساسي في البداية ليتناسب مع استدعائك
  final List<Widget> children;
  final Color? backgroundColor;

  const CardItem(
      this.children, { // هنا التعديل ليناسب الاستدعاء المباشر
        super.key,
        this.backgroundColor,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
       // color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}