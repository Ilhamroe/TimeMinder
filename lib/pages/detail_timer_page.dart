import 'package:flutter/material.dart';
import 'package:mobile_time_minder/models/list_timer.dart';

class DetailTimer extends StatelessWidget {
  final Timer timer;
  const DetailTimer({Key? key, required this.timer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: GestureDetector(
            onTap: () {
              // Navigasi kembali ke HomePage saat teks ditekan
              Navigator.pop(context);
            },
            child: Text('Hello World!'),
          ),
        ),
      ),
    );
  }
}
