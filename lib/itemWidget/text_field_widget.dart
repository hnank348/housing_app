import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isNum;
  final int maxLines;

  const TextFieldWidget(
      this.controller,
      this.label,
      this.icon, {
        super.key,
        this.isNum = false,
        this.maxLines = 1,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xff2D5C7A), size: 22),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          floatingLabelStyle: const TextStyle(color: Color(0xff2D5C7A)),

          filled: true,
          fillColor: const Color(0xFFF1F4F8),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xff2D5C7A), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'required'.tr();
          }
          return null;
        },
      ),
    );
  }
}