import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final List<Widget> children;
  final Color? backgroundColor;

  const CardItem(
      this.children, {
        super.key,
        this.backgroundColor,
      });

  @override
  Widget build(BuildContext context) {
    // التأكد إذا كان التطبيق في الوضع الداكن حالياً
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // استخدام اللون الممرر، وإذا لم يوجد، يتم اختيار لون الكارد المناسب للمود الحالي
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),

        // تعديل الإطار ليتناسب مع الوضعين
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(0.1) // إطار خفيف جداً في الوضع الداكن
              : Colors.grey.withOpacity(0.2), // إطار رمادي في الوضع الفاتح
          width: 1.5,
        ),

        // تعديل الظل ليتناسب مع الوضع الداكن (الظل القوي في الداكن يبدو سيئاً)
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3) // ظل أغمق للوضع الداكن
                : Colors.black.withOpacity(0.04), // ظل خفيف جداً للوضع الفاتح
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