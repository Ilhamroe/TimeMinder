import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
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
        leading: GestureDetector(
          onTap: () {
            _showPopup();
          },
          child: Icon(
            CupertinoIcons.lessthan_circle,
            color: cetaceanBlue,
          ),
        ),
        title: Column(
          children: [
            SizedBox(height: 20),
            Text(
              _judul,
              style: TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.w600,
                color: cetaceanBlue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              _deskripsi,
              style: TextStyle(
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
                      duration: timeInSec,
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
                      color: _controller.isPaused ? red : cetaceanBlue,
                      fontWeight: FontWeight.bold,
                    ),
                    onComplete: () {
                      _showPopup();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ));
                      }
                    ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (isStarted)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.resume();
                            isStarted = false;
                          });
                        },
                        child: Icon(
                          Icons.play_arrow_outlined,
                          color: blueJeans,
                          size: 40,
                        ),
                      ),
                    if (!isStarted)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.pause();
                            isStarted = true;
                          });
                        },
                        child: Icon(
                          Icons.pause,
                          color: blueJeans,
                          size: 40,
                        ),
                      ),
                    SizedBox(width: 100),
                    IconButton(
                      onPressed: _showPopup,
                      icon: Icon(Icons.check),
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
}
