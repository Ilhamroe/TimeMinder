import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';
import 'package:mobile_time_minder/models/notif.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
  late List<Map<String, dynamic>> allData = [];
  bool isLoading = false;
  bool _isSoundPlayed = false;
  final player = AudioPlayer();
  late CountDownController _controller;

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

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModalConfirm();
      },
    );
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  void resumeTimer() {
    setState(() {
      _controller.resume();
      isStarted = false;
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
      isStarted = true;
      _showNotification("Timer dijeda");
      if (_isSoundPlayed) {
        player.play(AssetSource("sounds/pause.wav"));
        _isSoundPlayed = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataByID();
    _convertTimeInSec(context, _jam, _menit, _detik);
    _controller = CountDownController();
    Notif.initialize(flutterLocalNotificationsPlugin);
    player.onPlayerComplete.listen((event) {
      setState(() {
        _isSoundPlayed = false;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            Text(
              _judul,
              style: const TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.w600,
                color: cetaceanBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
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
                    colors: [_controller.isPaused ? red : ripeMango, offOrange],
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
                    _refreshData();
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const NavbarBottom(),
                    //   ),
                    // );
                    Navigator.popAndPushNamed(context, AppRoutes.navbar);
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
                          onTap: isStarted ? resumeTimer : pauseTimer,
                          child: SvgPicture.asset(
                            isStarted
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
  //                         _showNotification("Timer dihentikan");
  //                         // _timer.cancel();
  //                         // Navigator.push(
  //                         //   context,
  //                         //   MaterialPageRoute(
  //                         //     builder: (context) => const NavbarBottom(),
  //                         //   ),
  //                         // );
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
