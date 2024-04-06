import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

class TimerView extends StatefulWidget {
  final int timerIndex;

  const TimerView({Key? key, required this.timerIndex}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerState();
}

class _TimerState extends State<TimerView> {
  late Timer _timer;

  late int timeInSec;
  late String _waktuMentah;
  late String _judul;
  late String _deskripsi;
  late int _jam;
  late int _menit;
  late int _detik;
  bool isStarted = false;
  int focusedMins = 0;

  @override
  void initState() {
    super.initState();
    _getDataByID();
    _convertTimeInSec(context, _jam, _menit, _detik);
  }

  void _getDataByID() {
    _timer = Timerlist[widget.timerIndex];
    _waktuMentah = _timer.time;
    _judul = _timer.title;
    _deskripsi = _timer.description;
    _parseWaktuMentah(_waktuMentah);
  }

  void _parseWaktuMentah(String time) {
    List<String> bagian = time.split(':');
    _jam = int.parse(bagian[0]);
    _menit = int.parse(bagian[1]);
    _detik = int.parse(bagian[2]);
  }

  void _convertTimeInSec(BuildContext context, jam, menit, detik) {
    setState(() {
      timeInSec = jam * 3600 + menit * 60 + detik;
    });
  }

  final CountDownController _controller = CountDownController();
  void startTimer() {
    const onesec = Duration(seconds: 1);
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalConfirm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20),
            Text(
              _judul,
              style: const TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.w600,
                color: cetaceanBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              _deskripsi,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: pureWhite,
        toolbarHeight: 80,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: pureWhite,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1,
            vertical: MediaQuery.of(context).size.height * 0.1,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularCountDownTimer(
                  duration: timeInSec,
                  initialDuration: 0,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.4,
                  controller: _controller,
                  ringColor: ring,
                  fillColor: _controller.isPaused ? red : ripeMango,
                  fillGradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      _controller.isPaused ? red : ripeMango,
                      offOrange
                    ],
                  ),
                  strokeWidth: 20.0,
                  isReverse: true,
                  isReverseAnimation: false,
                  strokeCap: StrokeCap.round,
                  autoStart: true,
                  textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.1,
                    color: _controller.isPaused ? red : cetaceanBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  onChange: (String timeStamp) {},
                  onComplete: () {
                    Navigator.popUntil(
                        context, ModalRoute.withName(AppRoutes.home));
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (isStarted)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              color: offBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.resume();
                                isStarted = false;
                              });
                            },
                            child: SvgPicture.asset(
                              "assets/images/play.svg",
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.width * 0.07,
                              color: blueJeans,
                            ),
                          ),
                        ],
                      ),
                    if (!isStarted)
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              color: offBlue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _controller.pause();
                                isStarted = true;
                              });
                            },
                            child: SvgPicture.asset(
                              "assets/images/pause.svg",
                              width: MediaQuery.of(context).size.width * 0.07,
                              height: MediaQuery.of(context).size.width * 0.07,
                              color: blueJeans,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(
                            color: offBlue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        IconButton(
                          onPressed: _showPopup,
                          icon: SvgPicture.asset(
                            "assets/images/check.svg",
                            width: MediaQuery.of(context).size.width * 0.07,
                            height: MediaQuery.of(context).size.width * 0.07,
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
    );
  }
}
