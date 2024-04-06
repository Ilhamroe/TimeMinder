import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double fontSize;
  final String fontFamily;

  const CustomTextField({
    super.key,
    this.labelText = "Default Label",
    this.fontSize = 14,
    this.fontFamily = 'Nunito',
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final adjustedFontSize = screenWidth * 0.04;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: adjustedFontSize,
          ),
        ),
      ],
    );
  }
}
