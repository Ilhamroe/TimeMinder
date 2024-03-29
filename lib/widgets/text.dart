import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double fontSize;
  final String fontFamily;

  const CustomTextField({
    Key? key,
    this.labelText = "Default Label",
    this.fontSize = 16,
    this.fontFamily = 'Nunito',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText ?? "Default Label",
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
          ),
        ),
      ],
    );
  }
}
