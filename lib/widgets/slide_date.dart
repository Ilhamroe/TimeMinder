import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:table_calendar/table_calendar.dart';

class SlideDate extends StatefulWidget {
  const SlideDate({super.key});

  @override
  State<SlideDate> createState() => _SlideDateState();
}

class _SlideDateState extends State<SlideDate> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  @override
  Widget build(BuildContext context) {
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
}