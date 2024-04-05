import 'package:flutter/material.dart';

class Timer {
  Color color;
  String title;
  String image;
  String description;
  String time;

  Timer({
    required this.color,
    required this.image,
    required this.title,
    required this.description,
    required this.time,
  });
}

var Timerlist = [
  Timer(
    color: Color(0xFFBC78FF),
    image: 'assets/images/cat1.svg',
    title: 'Belajar',
    description: 'Fokus belajar dengan time block',
    time: '00:20:30',
  ),
  Timer(
    color: Color(0xFFE53E42),
    image: 'assets/images/cat1.svg',
    title: 'Pomodoro',
<<<<<<< HEAD
    description: 'Belajar dengan metode pomodoro',
    time: '00:40:00',
  ),
];
