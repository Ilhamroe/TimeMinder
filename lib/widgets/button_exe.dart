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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final verticalPadding = screenHeight * 0.025;
    final horizontalPadding = screenWidth * 0.12;

    return Center(
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
            EdgeInsets.symmetric(
                vertical: verticalPadding, horizontal: horizontalPadding),
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
