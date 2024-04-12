import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_time_minder/models/notif.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotifView extends StatefulWidget {
  const NotifView({super.key});

  @override
  State<NotifView> createState() => _NotifViewState();
}

class _NotifViewState extends State<NotifView> {
  @override
  void initState() {
    super.initState();
    Notif.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3AC3CB), Color(0xFFF85187)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.blue.withOpacity(0.5),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            width: 200,
            height: 80,
            child: ElevatedButton(
                onPressed: () {
                  Notif.showBigTextNotification(
                      id: DateTime.now()
                          .millisecondsSinceEpoch
                          .remainder(100000),
                      title: "Halo!",
                      body: "Terimakasih sudah menggunakan TimeMinder!",
                      fln: flutterLocalNotificationsPlugin);
                },
                child: const Text("click")),
          ),
        ),
      ),
    );
  }
}
