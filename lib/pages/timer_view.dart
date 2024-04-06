import 'dart:async';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/theme.dart';
import 'package:mobile_time_minder/pages/custom_timer.dart';
import 'package:mobile_time_minder/services/homepage.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/theme.dart';

class TimerView extends StatefulWidget {
  final int timerIndex;

  const TimerView({Key? key, required this.timerIndex}) : super(key: key);

  @override
  State<TimerView> createState() => _TimerState();
}

class _TimerState extends State<TimerView> {
  late Timer _timer;

  Color iconColor = blueJeans;
  Color backgroundColor = offGrey;


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

  void _getDataByID(){
    _timer = Timerlist[widget.timerIndex];
    _waktuMentah = _timer.time;
    _judul = _timer.title;
    _deskripsi = _timer.description;
    _parseWaktuMentah(_waktuMentah);
  }

  void _parseWaktuMentah(String time) {
    List<String> bagian  = time.split(':');
    _jam = int.parse(bagian[0]);
    _menit = int.parse(bagian[1]);
    _detik = int.parse(bagian[2]);
  }


  void _convertTimeInSec(BuildContext context, jam, menit, detik){
    setState(() {
      timeInSec =  jam * 3600 + menit * 60 + detik;
    });
  }
  final CountDownController _controller = CountDownController();
  void startTimer(){
      const onesec = Duration(seconds: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(),
        title:Column(
          children: [
            SizedBox(height: 20),
            Text(
              _judul,
              style: TextStyle(),
              textAlign: TextAlign.center,
            ),
            Text(
              _deskripsi,
              style: TextStyle(fontSize: 14, color: Colors.black), // Atur gaya teks deskripsi
            ),
          ],
        ),
        centerTitle: true,
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
                  ringColor: app_background,
                  fillColor: _controller.isPaused? merah : ripeMango,
                  fillGradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [_controller.isPaused? merah : ripeMango, offOrange], // Your gradient colors
                  ),
                  strokeWidth: 20.0,
                  isReverse: true,
                  isReverseAnimation: false,
                  strokeCap: StrokeCap.round,
                  autoStart: true,
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    color: _controller.isPaused ? merah : cetaceanBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  onChange: (String timeStamp) {
                    // Here, do whatever you want
                    debugPrint('Countdown Changed $timeStamp');
                    // int currentTime = int.tryParse(timeStamp) ?? 0;
                    // setState(() {
                    //   currentTimerValue = currentTime;
                    // });
                  },
                  onComplete: () {
                    _showPopupEnd();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomTimer(),
                      ),
                    );
                  },
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
                            // Update warna saat tombol pause ditekan
                            iconColor = blueJeans;
                            backgroundColor = merah;
                          });
                        },
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: iconColor,
                          size: 40,
                        ),
                      ),
                    if (!isStarted)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.pause();
                            // Update warna saat tombol pause ditekan
                            iconColor = merah;
                            backgroundColor = ripeMango;
                          });
                        },
                        child: Icon(
                          Icons.pause_rounded,
                          color: iconColor,
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
  void _showPopupEnd() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: SvgPicture.asset("assets/images/cat3.svg"),
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min, // Menentukan ukuran minimum untuk Column
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Kembali ke Beranda ?",
                  textAlign:
                  TextAlign.center, // Mengatur teks menjadi di tengah
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomTimer(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    yellow_timer, // Gunakan warna dari variabel state
                  ),
                  child: Text("Oke"),
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: SvgPicture.asset("assets/images/cat3.svg"),
          ),
          content: Column(
            mainAxisSize:
            MainAxisSize.min, // Menentukan ukuran minimum untuk Column
            children: <Widget>[
              SizedBox(height: 30),
              Center(
                child: Text(
                  "Apakah Anda Yakin ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  // Mengatur teks menjadi di tengah
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Colors.grey, // Gunakan warna dari variabel state
                  ),
                  child: Text(
                    "Tidak",
                    style: TextStyle(
                      backgroundColor: Colors.grey,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomTimer(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    yellow_timer, // Gunakan warna dari variabel state
                  ),
                  child: Text(
                    "Iya",
                    style: TextStyle(
                      backgroundColor: yellow_timer,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
