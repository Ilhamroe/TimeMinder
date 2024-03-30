import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:list_timer/list_timer.dart';
=======
import 'package:mobile_time_minder/pages/custom_timer.dart';
// import 'package:mobile_time_minder/pages/home_page.dart';
>>>>>>> 1a6b368e9373e2a9d8e1315dfa992cc58896dca3

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
<<<<<<< HEAD
      theme: ThemeData(useMaterial3: false),
      home: const ListTimer(),
=======
      home: CustomTimer(),
>>>>>>> 1a6b368e9373e2a9d8e1315dfa992cc58896dca3
    );
  }
}
