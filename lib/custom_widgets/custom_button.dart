import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  //const CustomButton({key}) : super(key: key);
  CustomButton(
      { required this.text ,
        this.backgroundColor = Colors.white,
        this.textColor = Colors.white,
        required this.onPressed });
  final String text;
  Color textColor;
  Color backgroundColor;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
            ),
            textAlign: TextAlign.center,
          ),
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor)),
    );
  }
}

