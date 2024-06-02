import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/models/list_jobs.dart';
import 'package:time_minder/services/logic_timer.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/services/notif.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class CombinedTimerPage extends StatefulWidget {
  final int id;

  const CombinedTimerPage({super.key, required this.id});

  @override
  State<CombinedTimerPage> createState() => _CombinedTimerPageState();
}

class _CombinedTimerPageState extends State<CombinedTimerPage> {
  final _cDController = CountDownController();
  final _player = AudioPlayer();
  late Future<List<Map<String, dynamic>>> _dataFuture;
  late List<ListJobs> _jobsTimer;
  late int _currentJobIndex;
  late String _title;
  late String _description;
  late int _timer;
  late int _rest;
  late int _interval;
  bool isStarted = false;
  late int sum;
  late DateTime endTime;
  DateTime? pauseTime;
  var pauseCount = 0;
  var istirahatCount = 0;

  void _pauseOrResume() {
    setState(() {
      if (_cDController.isPaused) {
        pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
        pauseTime = null;
        _player.play(AssetSource('sounds/resume.wav'));
        _cDController.resume();
        _showNotification('Timer dilanjutkan');
      } else {
        pauseTime = DateTime.now();
        _player.play(AssetSource('sounds/pause.wav'));
        _cDController.pause();
        _showNotification('Timer dihentikan');
      }
    });
  }

  void _clearJobs() {
    setState(() {
      _currentJobIndex = 0;
      _cDController.restart(
          duration: _jobsTimer[_currentJobIndex].duration * 60);
      _showNotification('Timer Selesai');
      _player.play(AssetSource('sounds/nothing.wav'));
    });
  }

  int findIntervalLoop(int interval) {
    return interval * 2 + 1;
  }

  void addData() async {
    final elapsed = (_timer * 60) -
        (endTime
            .difference(DateTime.now().subtract(Duration(seconds: pauseCount)))
            .inSeconds) -
        (_rest * 60 * istirahatCount);
    final completed =
        elapsed >= ((_timer * 60) + (_rest * 60 * istirahatCount)) ? 1 : 0;

    await DBCalendar.createData(
      _title,
      _description,
      (_timer * 60),
      elapsed,
      completed,
      DateTime.now().toIso8601String(),
    );
  }

  @override
  void initState() {
    super.initState();
    Notif.initialize(flutterLocalNotificationsPlugin);
    _dataFuture = SQLHelper.getSingleData(widget.id);
    _currentJobIndex = 0;
    _title = '';
    _description = '';
    _timer = 0;
    _rest = 0;
    _interval = 0;
    _jobsTimer = [];
    _cDController.pause();
    _initVariable();
  }

  void _initVariable() async {
    await _dataFuture.then((value) {
      final data = value.isNotEmpty ? value[0] : {};
      setState(() {
        _title = data['title'] ?? '';
        _description = data['description'] ?? '';
        _timer = data['timer'] ?? 0;
        _rest = data['rest'] ?? 0;
        _interval = data['interval'] ?? 0;
        final newJobs = TimerJobs(
          title: _title,
          description: _description,
          timer: _timer,
          rest: _rest,
          interval: _interval,
        );
        _jobsTimer = newJobs.getAllMode(_timer, _rest, _interval);
        sum = ((_timer + (_rest * _interval)) * 60);
      });
    });
    endTime = DateTime.now().add(Duration(seconds: (_timer * 60)));
  }

  Future<void> _queueTimerJob() async {
    setState(() {
      if (_currentJobIndex < _jobsTimer.length - 1) {
        if (_cDController.isPaused) {
          pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
          pauseTime = null;
        }
        _cDController.restart(
            duration: _jobsTimer[++_currentJobIndex].duration);
        if (_jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
          istirahatCount++;
          _player.play(AssetSource('sounds/jobs_rest.wav'));
          _showNotification("Waktunya Istirahat");
        }
        if (_jobsTimer[_currentJobIndex].type == 'FOKUS') {
          _player.play(AssetSource('sounds/job_focus.wav'));
          _showNotification("Istirahat Selesai");
        }
      } else {
        _player.play(AssetSource('sounds/end.wav'));
        _showNotification("Timer Selesai");
        _cDController.pause();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavbarBottom(),
          ),
        );
        addData();
      }
    });
  }

  Color getColorRing() {
    if (_cDController.isPaused ||
        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
      return red;
    } else {
      return ripeMango;
    }
  }

  Color getColor() {
    if (_cDController.isPaused ||
        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
      return offRed;
    } else {
      return offYellow;
    }
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  // Future<bool> _onBackButtonPressed(BuildContext context) async {
  //   bool? exitApp = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return const AlertDialog();
  //     },
  //   );
  //   return exitApp ?? false;
  // }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await _showPopupBack(context);
    return exitApp ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20).w,
            onPressed: () {
              _showPopup();
            },
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 28.w,
              height: 28.h,
            ),
          ),
          title: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                _title,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w600,
                  color: cetaceanBlue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                _description,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14.sp,
                  color: cetaceanBlue,
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          toolbarHeight: 80.h,
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: pureWhite,
            ),
            width: screenSize.width,
            height: screenSize.height,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ).w,
            child: Center(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10).w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10).w,
                            color: getColor(),
                            border: Border.all(
                              color: getColorRing(),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            _jobsTimer[_currentJobIndex].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 20.sp,
                              color: cetaceanBlue,
                            ),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.07.h),
                        CircularCountDownTimer(
                            duration: _jobsTimer[_currentJobIndex].duration,
                            initialDuration: 0,
                            controller: _cDController,
                            width: screenSize.width * 0.5.w,
                            height: screenSize.width * 0.5.w,
                            ringColor: ring,
                            fillColor: getColorRing(),
                            fillGradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [getColorRing(), offOrange],
                            ),
                            strokeWidth: 20.0,
                            isReverse: true,
                            isReverseAnimation: false,
                            isTimerTextShown: true,
                            strokeCap: StrokeCap.round,
                            textStyle: TextStyle(
                              fontSize: 36.sp,
                              color:
                                  _cDController.isPaused ? red : cetaceanBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            onStart: () {
                              _player.play(AssetSource('sounds/start.wav'));
                              _showNotification("Timer dimulai");
                            },
                            onComplete: () => _queueTimerJob()),
                        SizedBox(height: screenSize.height * 0.07.h),
                        _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT'
                            ? Container(
                                child: SvgPicture.asset(
                                  'assets/images/cat_rest.svg',
                                  width: screenSize.width * 0.23.w,
                                  height: screenSize.width * 0.23.h,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              color: offBlue,
                                              borderRadius:
                                                  BorderRadius.circular(16).w,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(10.0).w,
                                            child: GestureDetector(
                                              onTap: _pauseOrResume,
                                              child: SvgPicture.asset(
                                                _cDController.isPaused
                                                    ? "assets/images/play.svg"
                                                    : "assets/images/pause.svg",
                                                width: 25.w,
                                                height: 25.h,
                                                color: blueJeans,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      isStarted
                                          ? Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0)
                                                      .w,
                                                ),
                                                const Text(
                                                  "Resume",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      color: cetaceanBlue),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0)
                                                      .w,
                                                ),
                                                const Text(
                                                  "Pause",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      color: cetaceanBlue),
                                                ),
                                              ],
                                            )
                                    ],
                                  ),
                                  SizedBox(width: screenSize.width * 0.2.w),
                                  Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50.w,
                                            height: 50.h,
                                            decoration: BoxDecoration(
                                              color: offBlue,
                                              borderRadius:
                                                  BorderRadius.circular(16).w,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showPopup();
                                            },
                                            icon: SvgPicture.asset(
                                              "assets/images/check.svg",
                                              width: screenSize.width * 0.07.w,
                                              height: screenSize.width * 0.07.h,
                                              color: blueJeans,
                                            ),
                                            color: blueJeans,
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                                vertical: 8.0)
                                            .w,
                                      ),
                                      const Text(
                                        "Finish",
                                        style: TextStyle(
                                            fontFamily: 'Nunito',
                                            color: cetaceanBlue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buttonConfirm() async {
    _clearJobs();
    if (pauseTime != null) {
      pauseCount += DateTime.now().difference(pauseTime!).inSeconds;
    }
    setState(() {
      _showNotification("Timer dihentikan");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarBottom(),
        ),
      );
      addData();
    });
  }

  Future<void> buttonConfirmBack() async {
    _clearJobs();
    setState(() {
      _showNotification("Timer dihentikan");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavbarBottom(),
        ),
      );
    });
  }

  void _showPopup() {
    final screenSize = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.47).w,
          ),
          content: SizedBox(
            // width: screenSize.width * 0.55.w,
            // height: screenSize.height * 0.30.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenSize.height * 0.14.h,
                  child: SvgPicture.asset(
                    'assets/images/confirm_popup.svg',
                    fit: BoxFit.contain,
                    width: screenSize.width * 0.2.w,
                    height: screenSize.width * 0.2.h,
                  ),
                ),
                Text(
                  (_jobsTimer[_currentJobIndex].type == 'ISTIRAHAT')
                      ? "Progress tidak tersimpan,\napakah anda yakin?"
                      : 'Apakah kamu yakin\nmenyelesaikan timer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16.84.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.79).w,
                        color: halfGrey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Tidak",
                          style:
                              TextStyle(fontSize: 16.84.sp, color: pureWhite),
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.79).w,
                        color: ripeMango,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_jobsTimer[_currentJobIndex].type ==
                              'ISTIRAHAT') {
                            buttonConfirmBack();
                          } else {
                            buttonConfirm();
                          }
                        },
                        child: Text(
                          "Ya",
                          style:
                              TextStyle(fontSize: 16.84.sp, color: pureWhite),
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
  }

  Future<bool?> _showPopupBack(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: pureWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.47).w,
          ),
          content: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: screenSize.height * 0.14.h,
                  child: SvgPicture.asset(
                    'assets/images/confirm_popup.svg',
                    fit: BoxFit.contain,
                    width: screenSize.width * 0.2.w,
                    height: screenSize.width * 0.2.h,
                  ),
                ),
                Text(
                  (_jobsTimer[_currentJobIndex].type == 'ISTIRAHAT')
                      ? "Progress tidak tersimpan,\napakah kamu yakin?"
                      : 'Apakah kamu yakin\nmenyelesaikan timer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 16.84.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.79).w,
                        color: halfGrey,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Tidak",
                          style: TextStyle(fontSize: 16.84.sp, color: pureWhite),
                        ),
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0).w,
                        color: ripeMango,
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (_jobsTimer[_currentJobIndex].type ==
                              'ISTIRAHAT') {
                            buttonConfirmBack();
                          } else {
                            buttonConfirm();
                          }
                        },
                        child: Text(
                          "Ya",
                          style: TextStyle(fontSize: 16.84.sp, color: pureWhite),
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
    ).then((value) => value ?? false); // Ensuring a non-null return value
  }
}
