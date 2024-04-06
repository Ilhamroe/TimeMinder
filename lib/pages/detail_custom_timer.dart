import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/pages/custom_timer.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter/animation.dart';
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
  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  int currentTimerValue = 0;
  bool _isLoading = false;

  bool _isTimerRunning = false;
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

  int get totalTime => inTimeBreak;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _showPopup();
          },
          icon: SvgPicture.asset(
            "assets/images/button_back.svg",
            width: 30,
            height: 30,
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
            SizedBox(height: 10),
          ],
        ),
        centerTitle: true,
        backgroundColor: pureWhite,
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: pureWhite,
          ),
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
                    ringColor: ring,
                    fillColor: _controller.isPaused ? red : ripeMango,
                    fillGradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        _controller.isPaused ? red : ripeMango,
                        offOrange
                      ], // Your gradient colors
                    ),
                    strokeWidth: 20.0,
                    isReverse: true,
                    isReverseAnimation: false,
                    strokeCap: StrokeCap.round,
                    autoStart: true,
                    textStyle: TextStyle(
                      fontSize: 33.0,
                      color: _controller.isPaused ? red : cetaceanBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    onChange: (String timeStamp) {
                      // Here, do whatever you want
                      // debugPrint('Countdown Changed $timeStamp');
                      // int currentTime = int.tryParse(timeStamp) ?? 0;
                      // setState(() {
                      //   currentTimerValue = currentTime;
                      // });
                    },
                    onComplete: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(AppRoutes.home));
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_isTimerRunning)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: offBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.resume();
                                  _isTimerRunning = false;
                                });
                              },
                              child: SvgPicture.asset(
                                "assets/images/play.svg",
                                width: 30,
                                height: 30,
                                color: blueJeans,
                              ),
                            ),
                          ],
                        ),
                      if (!_isTimerRunning)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: offBlue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _controller.pause();
                                  _isTimerRunning = true;
                                });
                              },
                              child: SvgPicture.asset(
                                "assets/images/pause.svg",
                                width: 30,
                                height: 30,
                                color: blueJeans,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(width: 100),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: offBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          IconButton(
                            onPressed: _showPopup,
                            icon: SvgPicture.asset(
                              "assets/images/check.svg",
                              width: 30,
                              height: 30,
                              color: blueJeans,
                            ),
                            color: blueJeans,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
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
