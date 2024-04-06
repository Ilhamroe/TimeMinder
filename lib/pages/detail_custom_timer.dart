import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

class DetailTimer extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailTimer({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTimer> createState() => _DetailTimerState();
}

class _DetailTimerState extends State<DetailTimer> {
  bool _isLoading = false;
  bool _isTimerRunning = false; // Menyimpan status timer
  bool statusSwitch = false;
  bool hideContainer = true;
  late List<Map<String, dynamic>> _allData = [];
  late CountDownController _controller;

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
    _controller = CountDownController();
    _refreshData();
  }

  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            _showPopup();
          },
          child: const Icon(
            CupertinoIcons.lessthan_circle,
            color: cetaceanBlue,
          ),
        ),
        title: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              data['title'],
              style: const TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.w600,
                color: cetaceanBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              data['description'],
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 100,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularCountDownTimer(
                  duration: inTimeBreak,
                  initialDuration: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  controller: _controller,
                  ringColor: offGrey,
                  fillColor: _controller.isPaused ? red : ripeMango,
                  strokeWidth: 20.0,
                  isReverse: true,
                  isReverseAnimation: true,
                  strokeCap: StrokeCap.round,
                  autoStart: true,
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    color: _controller.isPaused ? red : red,
                    fontWeight: FontWeight.bold,
                  ),
                  onComplete: () {
                    _showPopup();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_isTimerRunning)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.resume();
                            _isTimerRunning = false;
                          });
                        },
                        child: const Icon(
                          Icons.play_arrow_outlined,
                          color: blueJeans,
                          size: 40,
                        ),
                      ),
                    if (!_isTimerRunning)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.pause();
                            _isTimerRunning = true;
                          });
                        },
                        child: const Icon(
                          Icons.pause,
                          color: blueJeans,
                          size: 40,
                        ),
                      ),
                    const SizedBox(width: 100),
                    IconButton(
                      onPressed: _showPopup,
                      icon: const Icon(Icons.check),
                      color: blueJeans,
                      iconSize: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModalConfirm();
      },
    );
  }
}
