import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/detail_page/tooltip_detailpage.dart';
import 'package:time_minder/services/tooltip_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final calendarKey = GlobalKey();
  final detailTimerKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;
  bool isSaved = true;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late List<Map<String, dynamic>> allData = [];
  bool isLoading = false;
  bool isOptionOpen = false;

  void _initdetailPageInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: detailPageTargets(
        calendarKey: calendarKey,
        detailTimerKey: detailTimerKey,
      ),
      pulseEnable: false,
      colorShadow: darkGrey,
      paddingFocus: 20,
      hideSkip: true,
      opacityShadow: 0.5,
      onFinish: () {
        // print("Completed!");
        SaveDetailPageTour().saveDetailPageStatus();
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(milliseconds: 30), () {
      SaveDetailPageTour().getDetailPageStatus().then((value) => {
            if (value == false)
              {
                // print("User has not seen this tutor"),
                tutorialCoachMark.show(context: context)
              }
            // else
            //   {print("User has seen this tutor")}
          });
    });
  }

  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await DBCalendar.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _initdetailPageInAppTour();
    _showInAppTour();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        surfaceTintColor: pureWhite,
        centerTitle: true,
        backgroundColor: pureWhite,
        title: const Text(
          'Detail',
          style: TextStyle(fontFamily: 'Nunito-Bold'),
        ),
        leading: IconButton(
          iconSize: Checkbox.width,
          key: const Key('back'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NavbarBottom(),
              ),
            );
          },
          padding: const EdgeInsets.only(left: 20).w,
          icon: SvgPicture.asset(
            "assets/images/button_back.svg",
            width: 28.w,
            height: 28.h,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
              child: Container(
                key: calendarKey,
                padding: const EdgeInsets.symmetric(vertical: 7.0).w,
                decoration: BoxDecoration(
                  border: Border.all(color: halfGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(6.0)).w,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _slideDate(),
                    ),
                    IconButton(
                      icon: isOptionOpen
                          ? SvgPicture.asset(
                              "assets/images/chev-down.svg",
                              width: 20.w,
                              height: 20.h,
                            )
                          : SvgPicture.asset(
                              "assets/images/chev-up.svg",
                              width: 20.w,
                              height: 20.h,
                            ),
                      onPressed: () {
                        setState(() {
                          isOptionOpen = !isOptionOpen;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            isOptionOpen
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0).w,
                        child: _kalender(),
                      ),
                      const Divider(
                        color: ripeMango,
                      ),
                    ],
                  )
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                      .w,
              child: Column(
                key: detailTimerKey,
                children: [
                  Container(
                    // padding: const EdgeInsets.symmetric(
                    //         horizontal: 5.0, vertical: 8.0)
                    //     .w,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/detail.svg',
                          color: ripeMango,
                          height: 20.h,
                          width: 20.w,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0).w,
                          child: Text(
                            "Detail",
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: ripeMango,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  EasyDateTimeLine _slideDate() {
    return EasyDateTimeLine(
      initialDate: _focusedDay,
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDay = selectedDate;
          _focusedDay = selectedDate;
        });
      },
      locale: "id_id",
      timeLineProps: EasyTimeLineProps(
        hPadding: 12.w,
        separatorPadding: 7.w,
      ),
      headerProps: const EasyHeaderProps(
        showHeader: false,
      ),
      activeColor: cetaceanBlue,
      dayProps: EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBorder,
        todayHighlightColor: cetaceanBlue,
        borderColor: cetaceanBlue,
        dayStructure: DayStructure.dayStrDayNum,
        width: 31.68.w,
        height: 42.24.h,
        activeDayStyle: DayStyle(
            dayStrStyle: TextStyle(
              fontSize: 8.8.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: pureWhite),
            dayNumStyle: TextStyle(
              fontSize: 12.32.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: pureWhite),
            ),
        inactiveDayStyle: DayStyle(
          dayStrStyle: TextStyle(
              fontSize: 8.8.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: cetaceanBlue),
            dayNumStyle: TextStyle(
              fontSize: 12.32.sp,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              color: cetaceanBlue),
            ),
      ),
    );
  }

  TableCalendar _kalender() {
    return TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      locale: 'id_ID',
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        todayDecoration: BoxDecoration(
          color: cetaceanBlue,
          border: Border.all(color: cetaceanBlue),
          shape: BoxShape.circle,
        ),
        todayTextStyle: const TextStyle(color: pureWhite),
        selectedDecoration: BoxDecoration(
          color: offBlue,
          border: Border.all(color: blueJeans),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(color: cetaceanBlue),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _selectedDay = focusedDay;
        });
      },
    );
  }

  Widget _buildListView() {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 5.0).w,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBCalendar.getSingleDate(_focusedDay),
        builder: (context, snapshot) {
          pureWhite;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dataList = snapshot.data!;
            if (dataList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 69.0).w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/cat_setting.svg",
                            width: 150.w,
                            height: 150.h,
                          ),
                          SizedBox(height: 12.82.h),
                          Text(
                            "Ayo tambahkan timer sesuai keinginanmu!",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14.sp,
                              color: darkGrey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: dataList.length,
                itemBuilder: (context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(top: 14.0).h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0).w,
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 19.0)
                          .w,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5).w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10)
                              .w,
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30.h,
                          ),
                        ),
                      ),
                      title: Text(
                        dataList[index]['title'],
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        dataList[index]['description'],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: (dataList[index]['elapsed'] >=
                              dataList[index]['timer'])
                          ? Image.asset(
                              "assets/images/vector.png",
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_formatTime(dataList[index]['elapsed'])} ",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: cetaceanBlue,
                                  ),
                                ),
                                Text(
                                  "/ ${_formatTime(dataList[index]['timer'])}",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                    color: cetaceanBlue,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

String _formatTime(int time) {
  if (time >= 3600) {
    int jam = time ~/ 3600;
    return '${jam}h';
  } else if (time >= 60) {
    int minutes = time ~/ 60;
    return '${minutes}m';
  } else {
    return '${time}s';
  }
}
