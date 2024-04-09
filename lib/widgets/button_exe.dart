import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color borderSideColor;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.borderSideColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(onPrimaryColor),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(
            width: 1,
            color: borderSideColor,
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.all(0), // No fixed padding
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size.zero,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16), // Adjust padding as needed
        child: Text(text),
      ),
    );
  }
}

