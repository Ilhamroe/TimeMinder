import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color borderSideColor;
  final VoidCallback onPressed;

const CustomButton({
    super.key,
    required this.text,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.borderSideColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: ElevatedButton(
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
            const EdgeInsets.symmetric(vertical: 20, horizontal: 47)
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
