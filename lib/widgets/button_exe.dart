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
    final double buttonWidth = MediaQuery.of(context).size.width * 0.3;
    final double buttonHeight = MediaQuery.of(context).size.height * 0.06;

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
          EdgeInsets.zero,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
