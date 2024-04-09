import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class DetailTimer extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailTimer({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTimer> createState() => _DetailTimerState();
}

class _DetailTimerState extends State<DetailTimer> {
  int currentTimerValue = 0;
  bool isLoading = false;

  bool _isTimerRunning = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  late List<Map<String, dynamic>> _allData = [];
  late CountDownController _controller;
  final player = AudioPlayer();
  bool _isSoundPlayed = false;
  late DateTime _startTime;
  late DateTime _endTime;

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
    _controller = CountDownController();
    Notif.initialize(flutterLocalNotificationsPlugin);
    player.onPlayerComplete.listen((event) {
      setState(() {
        _isSoundPlayed = false;
      });
    });
    _startTime = DateTime.now();
    _endTime = _startTime.add(Duration(minutes: inTimeMinutes));
    _scheduleBreakNotification();
  }

  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
        title: "TimeMinder",
        body: message,
        fln: flutterLocalNotificationsPlugin);
  }

  void _scheduleBreakNotification() {
    int totalDuration = inTimeMinutes + (inRestMinutes * interval);
    int restDuration = inRestMinutes * interval;

    for (int i = 1; i <= interval; i++) {
      int breakStartMinute =
          ((totalDuration / 2) - ((i * restDuration) / 2)).floor();
      int breakEndMinute = breakStartMinute + inRestMinutes;

      DateTime breakStart =
          _endTime.subtract(Duration(minutes: breakStartMinute.round()));
      DateTime breakEnd =
          _endTime.subtract(Duration(minutes: breakEndMinute.round()));

      _showNotification('Istirahat dimulai');
      _showNotification('Istirahat selesai');
    }
  }

  void _showNotification(String message) {
    int generateRandomId() {
      return DateTime.now().millisecondsSinceEpoch.remainder(100000);
    }
    Notif.showBigTextNotification(
        id: generateRandomId(),
        title: "TimeMinder",
        body: message,
        fln: flutterLocalNotificationsPlugin);
  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;

    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularCountDownTimer(
                    duration: inTimeBreak,
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
                      player.play(AssetSource('sounds/end.wav'));
                      _showNotification("Timer selesai");
                      _refreshData();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    onStart: () {
                      player.play(AssetSource('sounds/end.wav'));
                      _scheduleBreakNotification();
                      _showNotification("Timer dimulai");
                      _isSoundPlayed = true;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      if (_isTimerRunning)
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
                                  _isTimerRunning = false;
                                  _showNotification("Timer dilanjutkan");
                                  if (!_isSoundPlayed) {
                                    player
                                        .play(AssetSource("sounds/start.wav"));
                                    _isSoundPlayed = true;
                                  }
                                });
                              },
                              child: SvgPicture.asset(
                                "assets/images/play.svg",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height:
                                    MediaQuery.of(context).size.width * 0.07,
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
                                  _isTimerRunning = true;
                                  _showNotification("Timer dijeda");
                                  if (_isSoundPlayed) {
                                    player
                                        .play(AssetSource("sounds/pause.wav"));
                                    _isSoundPlayed = false;
                                  }
                                });
                              },
                              child: SvgPicture.asset(
                                "assets/images/pause.svg",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height:
                                    MediaQuery.of(context).size.width * 0.07,
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
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.68,
            height: MediaQuery.of(context).size.height * 0.42,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Image.asset(
                    'assets/images/confirm_popup.png',
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                const Text(
                  "Kembali ke Beranda,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "Apakah Anda yakin?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 21,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: halfGrey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text(
                          "Tidak",
                          style: TextStyle(color: offGrey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: ripeMango,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Ya",
                          style: TextStyle(color: offGrey),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return exitApp ?? false;
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
