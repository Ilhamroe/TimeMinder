import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final double? fontSize;
  final String fontFamily;

   const CustomTextField({
    super.key,
    this.labelText = "Default Label",
    this.fontSize,
    this.fontFamily = 'Nunito',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14.sp
          ),
        ),
      ],
    );
  }
}
