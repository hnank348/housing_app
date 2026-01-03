import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button( {super.key,required this.text,required this.color,required this.colorText,required this.onPressed});
  final String text;
  final Color color;
  final Color colorText;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 50,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:color,
          maximumSize: Size(330, 50),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: colorText,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}