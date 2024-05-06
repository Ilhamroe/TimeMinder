import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/bottom_navigation.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ViewListTimerPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const ViewListTimerPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewListTimerPage> createState() => _ViewListTimerPageState();
}

class _ViewListTimerPageState extends State<ViewListTimerPage> {
  bool isRestTime = false;
  int currentTimerValue = 0;
  bool _isTimerRunning = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool _isSoundPlayed = false;
  bool isLoading = false;
  late List<Map<String, dynamic>> allData = [];
  late CountDownController _controller;
  List<String> modeList = [];
  final player = AudioPlayer();
  late Timer _timer;
  late int _currentSecond;

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

  List<String> generateModeList(
      int inTimeSeconds, int inRestSeconds, int interval) {
    List<String> modeList = [];
    int totalBreakTime = inTimeSeconds + (inRestSeconds * (interval - 1));

    for (int i = 0; i < totalBreakTime; i++) {
      if (i % (inTimeSeconds + inRestSeconds) < inTimeSeconds) {
        modeList.add('Fokus');
      } else {
        modeList.add('Istirahat');
      }
    }

    return modeList;
  }

  Color _getRingColor(List<String> modeList, int time) {
    return modeList[time ~/ inTimeSeconds] == 'Fokus' ? offOrange : red;
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  // refresh data
  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  void resumeTimer() {
    setState(() {
      _controller.resume();
      _isTimerRunning = false;
      _showNotification("Timer dilanjutkan");
      if (!_isSoundPlayed) {
        player.play(AssetSource("sounds/resume.wav"));
        _isSoundPlayed = true;
      }
    });
  }

  void pauseTimer() {
    setState(() {
      _controller.pause();
      _isTimerRunning = true;
      _showNotification("Timer dijeda");
      if (_isSoundPlayed) {
        player.play(AssetSource("sounds/pause.wav"));
        _isSoundPlayed = false;
      }
    });
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModalConfirm();
      },
    );
  }

  void _startTimer() {
    _currentSecond = inTimeBreak;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSecond > 0) {
          _currentSecond--;
        } else {
          _timer.cancel();
          _controller.pause();
          _showNotification("Timer Selesai");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavbarBottom(),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _controller = CountDownController();
    Notif.initialize(flutterLocalNotificationsPlugin);
    player.onPlayerComplete.listen((event) {
      setState(() {
        _isSoundPlayed = false;
      });
    });
    modeList = generateModeList(inTimeSeconds, inRestSeconds, interval);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularCountDownTimer(
                duration: _currentSecond,
                initialDuration: 0,
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.4,
                controller: _controller,
                ringColor: ring,
                fillColor: _controller.isPaused ? red : ripeMango,
                fillGradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: _controller.isPaused
                      ? [red, offOrange]
                      : [ripeMango, offOrange],
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
                  player.play(AssetSource('sounds/end.wav'));
                  _showNotification("Timer Selesai");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavbarBottom(),
                    ),
                  );
                },
                onStart: () {
                  player.play(AssetSource('sounds/start.wav'));
                  _showNotification("Timer dimulai");
                  _isSoundPlayed = true;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                        onTap: _isTimerRunning ? resumeTimer : pauseTimer,
                        child: SvgPicture.asset(
                          _isTimerRunning
                              ? "assets/images/play.svg"
                              : "assets/images/pause.svg",
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
                        onPressed: () {
                          _showPopup();
                        },
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
    );
  }

  // Future<bool> _onBackButtonPressed(BuildContext context) async {
  //   bool? exitApp = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         content: SizedBox(
  //           width: MediaQuery.of(context).size.width * 0.68,
  //           height: MediaQuery.of(context).size.height * 0.42,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.2,
  //                 child: SvgPicture.asset(
  //                   'assets/images/confirm_popup.svg',
  //                   fit: BoxFit.contain,
  //                   width: MediaQuery.of(context).size.width * 0.2,
  //                   height: MediaQuery.of(context).size.width * 0.2,
  //                 ),
  //               ),
  //               const Text(
  //                 "Kembali ke Beranda,",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: 'Nunito',
  //                   fontSize: 15,
  //                 ),
  //               ),
  //               const SizedBox(height: 20.0),
  //               const Text(
  //                 "Apakah Anda yakin?",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: 'Nunito',
  //                   fontSize: 21,
  //                 ),
  //               ),
  //               const SizedBox(height: 20.0),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       color: halfGrey,
  //                     ),
  //                     child: TextButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop(false);
  //                       },
  //                       child: const Text(
  //                         "Tidak",
  //                         style: TextStyle(color: offGrey),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 30),
  //                   Container(
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10.0),
  //                       color: ripeMango,
  //                     ),
  //                     child: TextButton(
  //                       onPressed: () {
  //                         player.play(AssetSource('sounds/end.wav'));
  //                         _showNotification("Timer Selesai");
  //                         _timer.cancel();
  //                         Navigator.popAndPushNamed(context, AppRoutes.navbar);
  //                       },
  //                       child: const Text(
  //                         "Ya",
  //                         style: TextStyle(color: offGrey),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );

  //   return exitApp ?? false;
  // }
}
