import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/utils/colors.dart';

class FieldValidator extends StatelessWidget {
  final bool isFieldEmpty;
  final String desc;
  const FieldValidator({
    super.key, 
    required this.isFieldEmpty, 
    required this.desc
    });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isFieldEmpty,
        child: Padding(
          padding: const EdgeInsets.only(top: 6).r,
          child: Text(
            desc,
            style: TextStyle(
              color: redDeep, 
              fontSize: 14.sp,
              fontFamily: 'Nunito'
            ),
          ),
        ),
    );
  }
}