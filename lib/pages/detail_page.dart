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

  // late final ValueNotifier<List<dynamic>> _selectedEvents;

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
        SaveDetailPageTour().saveDetailPageStatus();
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(milliseconds: 30), () {
      SaveDetailPageTour().getDetailPageStatus().then((value) => {
            if (value == false) {tutorialCoachMark.show(context: context)}
          });
    });
  }

  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await DBCalendar.getAllData();
    final Map<DateTime, List<dynamic>> events = {};

    for (var entry in data) {
      final eventDate = DateTime.parse(entry['date']);
      if (events.containsKey(eventDate)) {
        events[eventDate]!.add(entry);
      } else {
        events[eventDate] = [entry];
      }
    }

    setState(() {
      allData = data;
      isLoading = false;
      // _selectedEvents = ValueNotifier(events[_selectedDay] ?? []);
    });
  }

  @override
  void initState() {
    super.initState();
    // _selectedEvents = ValueNotifier([]);
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
              padding: const EdgeInsets.symmetric(horizontal: 22.0).w,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 1.0, vertical: 8.0)
                        .w,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/detail.svg',
                          color: ripeMango,
                          height: 20.h,
                          width: 20.w,
                        ),
                        Container(
                          // padding:
                          //     const EdgeInsets.symmetric(horizontal: 8.0).w,
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
                  FutureBuilder(
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
                        return _buildListView();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 250));
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
      // eventLoader: (day) {
      //   return _selectedEvents.value;
      // },
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
        markerDecoration: const BoxDecoration(
          color: ripeMango,
          shape: BoxShape.circle,
        ),
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
    final filteredData = allData
        .where((data) => DateTime.parse(data['date']).day == _selectedDay.day)
        .toList();
    final groupedData = _groupData(filteredData);
    return isLoading
        ? const CircularProgressIndicator()
        : groupedData.isEmpty
            ? Container(
                padding: const EdgeInsets.all(8.0).r,
                margin: const EdgeInsets.only(top: 20.0).r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0).r,
                  color: pureWhite,
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/images/cat_setting.svg",
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0).r,
                      child: Text(
                        'Ayo tambahkan timer sesuai keinginanmu!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8.0).r,
                shrinkWrap: true,
                itemCount: groupedData.length,
                itemBuilder: (context, int index) {
                  final item = groupedData[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 13.0).r,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0).r,
                      color: offOrange,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 19.0)
                          .r,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.04,
                        ).r,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10)
                              .r,
                          color: heliotrope,
                          child: SvgPicture.asset(
                            'assets/images/cat1.svg',
                            height: 30.h,
                          ),
                        ),
                      ),
                      title: Text(
                        item['title'],
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        item['description'],
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: (item['count'] > 1) &&
                              (item['elapsed'] >= item['timer'])
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ripeMango,
                              ),
                              height: 24.h,
                              width: 24.w,
                              // padding: const EdgeInsets.all(8.0).r,
                              child: Center(
                                child: Text(
                                  "${item['count']}x",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontSize: 10.sp,
                                    color: offGrey,
                                  ),
                                ),
                              ),
                            )
                          : (item['elapsed'] >= item['timer'])
                              ? Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                  height: 24.h,
                                  width: 24.w,
                                  child: Image.asset(
                                    "assets/images/vector.png",
                                    color: ripeMango,
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${_formatTime(item['elapsed'])} ",
                                      style: TextStyle(
                                        fontFamily: 'Nunito-Bold',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                        color: cetaceanBlue,
                                      ),
                                    ),
                                    Text(
                                      "/ ${_formatTime(item['timer'])}",
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

  List<Map<String, dynamic>> _groupData(List<Map<String, dynamic>> dataList) {
    final Map<String, Map<String, dynamic>> groupedData = {};

    for (var data in dataList) {
      final key =
          "${data['title']}-${data['description']}-(${data['elapsed']} >= ${data['timer']})";

      if (groupedData.containsKey(key)) {
        groupedData[key]!['count'] += 1;
      } else {
        groupedData[key] = {
          'title': data['title'],
          'description': data['description'],
          'timer': data['timer'],
          'elapsed': data['elapsed'],
          'count': 1,
        };
      }
    }

    return groupedData.values.toList();
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
}
