import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DetailTimer extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailTimer({super.key, required this.data});

  @override
  State<DetailTimer> createState() => _DetailTimerState();
}

class _DetailTimerState extends State<DetailTimer> {
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool isTimerRunning = false; // Menyimpan status timer
  bool statusSwitch = false;
  bool hideContainer = true;
  late List<Map<String, dynamic>> allData = [];
  late CountdownController _controller; // Controller untuk Countdown widget

  int get inTimeMinutes => widget.data['timer'];
  int get inRestMinutes => widget.data['rest'] ?? 0;
  int get interval => widget.data['interval'] ?? 1;

  int get inTimeSeconds => inTimeMinutes * 60;
  int get inRestSeconds => inRestMinutes * 60;

  int get inTimeBreak {
    if (inRestMinutes == 0 && interval == 1) {
      return inTimeSeconds;
    } else if (inRestMinutes > 0 && interval == 1) {
      return inTimeSeconds + inRestSeconds;
    } else if (inRestMinutes > 0 && interval > 1) {
      return inTimeSeconds + (inRestSeconds * interval);
    } else {
      return inTimeSeconds;
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _controller = CountdownController();
  }

  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  void _toggleTimer() {
    setState(() {
      isTimerRunning = !isTimerRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data['description']),
            const SizedBox(height: 20),
            Countdown(
              controller: _controller,
              seconds: inTimeBreak,
              build: (_, double time) => Text(
                'Time left: ${time.toInt()}',
                style: const TextStyle(fontSize: 24, fontFamily: 'Nunito-Bold'),
              ),
              onFinished: () {
                setState(() {
                  isTimerRunning = false;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                isTimerRunning ? _controller.pause() : _controller.start();
                _toggleTimer();
              },
              child: Text(isTimerRunning ? 'Pause' : 'Play'),
            ),
            const SizedBox(height: 20),
            Text("Timer: ${data['timer']}"),
            Text("Rest: ${data['rest']}"),
            Text("Interval: ${data['interval']}"),
          ],
        ),
      ),
    );
  }
}