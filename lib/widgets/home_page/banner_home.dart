import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 200));
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
    height: screenSize.height * 0.18,
    width: screenSize.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22).w,
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: FutureBuilder(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: halfGrey,
                      strokeWidth: 4,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading data',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14.sp,
                        color: darkGrey,
                      ),
                    ),
                  );
                } else {
                  return allData.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Oops! Sepertinya kamu belum memulai timer hari ini',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  color: pureWhite,
                                ),
                              ),
                              Text(
                                'Yuk, mulai sekarang!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: 22.sp,
                                  color: pureWhite,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Hari ini kamu sudah fokus',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 20.89.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: pureWhite,
                                ),
                              ),
                              Text(
                                formatElapsedTime(totalElapsed),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: 24.sp,
                                  color: pureWhite,
                                ),
                              ),
                            ],
                          ),
                        );
                }
              },
            ),
          ),
        ),
      ],
    ),
  );
}

}
