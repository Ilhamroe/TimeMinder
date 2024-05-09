import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_time_minder/database/db_logger.dart';
import 'package:mobile_time_minder/services/tooltip_storage.dart';
import 'package:mobile_time_minder/widgets/tooltip_detailpage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/theme.dart';
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
        print("Completed!");
        SaveDetailPageTour().saveDetailPageStatus();
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(seconds: 2), () {
      SaveDetailPageTour().getDetailPageStatus().then((value) => {
            if (value == false)
              {
                print("User has not seen this tutor"),
                tutorialCoachMark.show(context: context)
              }
            else
              {print("User has seen this tutor")}
          });
    });
  }

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool isOptionOpen = false;

  @override
  void initState() {
    super.initState();
    _initdetailPageInAppTour();
    _showInAppTour();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                key: calendarKey,
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _slideDate(),
                    ),
                    IconButton(
                      icon: isOptionOpen
                          ? SvgPicture.asset(
                              "assets/images/option_up.svg",
                              width: 28,
                              height: 28,
                            )
                          : SvgPicture.asset(
                              "assets/images/option.svg",
                              width: 28,
                              height: 28,
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
            if (isOptionOpen) _kalender(),
            Container(
              height: 10.0,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.orange,
                    width: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                key: detailTimerKey,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        "assets/images/Detailpic.svg",
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 15.0),
                      const Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "nunito",
                          color: ripeMango,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
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
      initialDate: _selectedDay,
      onDateChange: (selectedDate) {
        setState(() {
          _selectedDay = selectedDate;
          _focusedDay = selectedDate;
        });
      },
      locale: "id_id",
      timeLineProps: const EasyTimeLineProps(
        hPadding: 5.0,
        separatorPadding: 5.0,
      ),
      disabledDates: [],
      headerProps: const EasyHeaderProps(
        showHeader: false,
      ),
      activeColor: cetaceanBlue,
      dayProps: const EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBorder,
        todayHighlightColor: cetaceanBlue,
        borderColor: cetaceanBlue,
        dayStructure: DayStructure.dayStrDayNum,
        width: 39,
        height: 60,
      ),
    );
  }

  TableCalendar _kalender() {
    return TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      weekendDays: [DateTime.saturday, DateTime.sunday],
      weekNumbersVisible: false,
      locale: 'id_ID',
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        cellMargin: EdgeInsets.all(4.0), // Jarak antar sel
        todayDecoration: BoxDecoration(
          color: cetaceanBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        selectedDecoration: BoxDecoration(
          color: offBlue, // Warna biru untuk hari yang ditekan
          borderRadius: BorderRadius.circular(10), // BorderRadius 10
          border: Border.all(color: blueJeans), // Warna border hitam
        ),
        selectedTextStyle: TextStyle(color: Colors.black),
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

  Future<bool> _checkDataExist(int date) async {
    try {
      List<Map<String, dynamic>> data = await SQLLogger.getSingleData(date);
      return data.isNotEmpty;
    } catch (e) {
      print("Error checking data existence: $e");
      return false;
    }
  }

  Widget _buildListView() {
    int formattedDate = int.parse(DateFormat('yyyyMMdd').format(_focusedDay));

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: SQLLogger.getSingleData(formattedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final dataList = snapshot.data!;
          if (dataList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/images/cat_setting.svg",
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tambahkan TimerMu Hari ini',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.grey,
                      fontFamily: "Nunito",
                    ),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];
                return ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['description']),
                  // Add more widgets as needed
                );
              },
            );
          }
        }
      },
    );
  }
}
