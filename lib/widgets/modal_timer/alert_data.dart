import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';

class AlertData extends StatefulWidget {
  const AlertData({super.key});

  @override
  _AlertDataState createState() => _AlertDataState();
}

class _AlertDataState extends State<AlertData> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 15000), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AlertDialog(
      surfaceTintColor: pureWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.47).w,
      ),
      title: Text(
        "Data tidak lengkap",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 22.sp,
        ),
      ),
      content: SizedBox(
        width: screenSize.width * 0.55.w,
        height: screenSize.height * 0.2.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: screenSize.height * 0.14.h,
              child: SvgPicture.asset(
                'assets/images/confirm_popup.svg',
                fit: BoxFit.contain,
                width: screenSize.width * 0.2.w,
                height: screenSize.width * 0.2.h,
              ),
            ),
            Text(
              'Nama Timer, Deskripsi, dan Waktu Fokus harus diisi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 16.84.sp,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 16.84.sp,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
