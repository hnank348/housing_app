import 'dart:io';
import 'package:flutter/material.dart';

class Images extends StatelessWidget {
  final File? mainImage;
  final List<File>? multiImages;
  final VoidCallback onTap;
  final Function(int)? onRemove;
  final bool isMulti;

  const Images({
    super.key,
    this.mainImage,
    this.multiImages,
    required this.onTap,
    this.onRemove,
    this.isMulti = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!isMulti) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.grey[800]! : Colors.grey.shade300),
            image: mainImage != null
                ? DecorationImage(image: FileImage(mainImage!), fit: BoxFit.cover)
                : null,
            boxShadow: [
              BoxShadow(
                  color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                  blurRadius: 10
              )
            ],
          ),
          child: mainImage == null
              ? const Icon(Icons.add_a_photo, size: 40, color: Color(0xff2D5C7A))
              : null,
        ),
      );
    }

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
                  color: isDark ? const Color(0xff2D5C7A).withOpacity(0.2) : const Color(0xff2D5C7A).withOpacity(0.1),
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
                  border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
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