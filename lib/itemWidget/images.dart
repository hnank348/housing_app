import 'dart:io';
import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final File? mainImage;          // للصورة الأساسية
  final List<File>? multiImages;   // للصور الإضافية
  final VoidCallback onTap;       // دالة الإضافة
  final Function(int)? onRemove;  // دالة الحذف (اختيارية)
  final bool isMulti;             // تحديد هل هو اختيار متعدد أم صورة واحدة

  const Images({
    super.key,
    this.mainImage,
    this.multiImages,
    required this.onTap,
    this.onRemove,
    this.isMulti = false, // القيمة الافتراضية هي صورة واحدة
  });

  @override
  Widget build(BuildContext context) {
    // --- 1. تصميم اختيار الصورة الأساسية (Main Image) ---
    if (!isMulti) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
            image: mainImage != null
                ? DecorationImage(image: FileImage(mainImage!), fit: BoxFit.cover)
                : null,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          child: mainImage == null
              ? const Icon(Icons.add_a_photo, size: 40, color: Color(0xff2D5C7A))
              : null,
        ),
      );
    }

    // --- 2. تصميم اختيار الصور الإضافية (Multiple Images) ---
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: (multiImages?.length ?? 0) + 1,
        itemBuilder: (context, index) {
          if (index == (multiImages?.length ?? 0)) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: 90,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: const Color(0xff2D5C7A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xff2D5C7A), width: 1),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined, color: Color(0xff2D5C7A)),
              ),
            );
          }

          return Stack(
            children: [
              Container(
                width: 90,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(multiImages![index]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 5,
                right: 15,
                child: InkWell(
                  onTap: () => onRemove?.call(index),
                  child: const CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}