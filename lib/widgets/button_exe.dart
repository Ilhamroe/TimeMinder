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
          EdgeInsets.zero,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height *
              0.025,
          horizontal: MediaQuery.of(context).size.width *
              0.12,
        ),
        child: Text(text),
      ),
    );
  }
}
