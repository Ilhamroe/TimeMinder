import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/utils/colors.dart';

class CardHome extends StatefulWidget {
  const CardHome({
    super.key,
  });

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  int totalElapsed = 0;
  late List<Map<String, dynamic>> allData = [];
  bool isLoading = false;
  DateTime focusedDay = DateTime.now();

  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data =
        await DBCalendar.getSingleDate(focusedDay);

    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  void _totalElapsed() async {
    final data = await DBCalendar.getSingleDate(DateTime.now());
    data.forEach((element) {
      totalElapsed += element['elapsed'] as int;
    });
  }

  String formatElapsedTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours jam ';
    }
    if (minutes > 0) {
      formattedTime += '$minutes menit ';
    }
    formattedTime += '$seconds detik';

    return formattedTime;
  }

  @override
  void initState() {
    super.initState();
    _totalElapsed();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * .18,
      width: screenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: cetaceanBlue,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/cardd.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22).w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  allData.isEmpty
                      ? Column(
                          children: [
                            Text(
                              'Oops! Sepertinya kamu belum\n memulai timer hari ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5.h,
                                  color: pureWhite),
                            ),
                            Text(
                              'Yuk, mulai sekarang!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: 21.sp,
                                  color: pureWhite),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Hari ini kamu sudah fokus',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: screenSize.width * 0.05.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5.h,
                                  color: pureWhite),
                            ),
                            Text(
                              formatElapsedTime(totalElapsed),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: screenSize.width * 0.067.sp,
                                  color: pureWhite),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
