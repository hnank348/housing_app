import 'package:flutter/material.dart';

class TextFieldItem extends StatelessWidget {
  const TextFieldItem({super.key,required this.hinit,required this.color,required this.hiding,
  this.icon,this.colorIcon,this.iconButton, this.controller,this.textInputType});
  final String hinit;
  final Color color;
  final Color? colorIcon;
  final Icon? icon;
  final IconButton? iconButton;
  final bool hiding;
 final TextEditingController? controller;
 final TextInputType? textInputType;
     
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),

      ),
       child: Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: controller,
          style: TextStyle(
            color: Colors.white
          ),
          obscureText: hiding,
          keyboardType: textInputType,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: icon,
            icon: iconButton,
            iconColor: colorIcon,
            prefixIconColor: colorIcon,
            contentPadding: EdgeInsets.
            only(left: 0, top: 15, bottom: 15),
            hintText: hinit,
            hintStyle: TextStyle(color: colorIcon),

          ),
        ),
      ),
    );
  }
}