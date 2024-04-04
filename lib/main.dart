import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:mobile_time_minder/pages/custom_timer.dart';
import 'package:mobile_time_minder/pages/list_timer.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListTimer(),
    );
  }
}
