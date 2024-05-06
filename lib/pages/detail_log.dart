import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mobile_time_minder/theme.dart';

class DetailLog extends StatefulWidget {
  const DetailLog({Key? key}) : super(key: key);

  @override
  State<DetailLog> createState() => _DetailLogState();
}

class _DetailLogState extends State<DetailLog> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
  }

  void refreshState(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Detail'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 32.0,
            ),
            _slideDate(),
            const SizedBox(
              height: 32.0,
            ),
            _kalender(),
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
      disabledDates: [],
      headerProps: const EasyHeaderProps(
        // showHeader: false,
      ),
      activeColor: cetaceanBlue,
      dayProps: const EasyDayProps(
        todayHighlightStyle: TodayHighlightStyle.withBackground,
        todayHighlightColor: halfGrey,
        borderColor: darkGrey,
      ),
    );
  }

  TableCalendar _kalender() {
    return TableCalendar(
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      weekNumbersVisible: false,
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
}
