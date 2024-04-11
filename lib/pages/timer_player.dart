import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/services/timer_jobs.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

class TimerPlayer extends StatefulWidget {
  final int id;
  final Map<String, dynamic> data;

  const TimerPlayer({super.key, required this.id, required this.data});

  @override
  State<TimerPlayer> createState() => _TimerPlayerState();
}

class _TimerPlayerState extends State<TimerPlayer> {
  Future<List<Map<String, dynamic>>>? _dataFuture;

  String _title = '';
  String _description = '';
  int _timer = 0;
  int _rest = 0;
  int _interval = 0;
  late List<ListJobs> _jobsTimer;
  int _currentJobIndex = 0;
  late CountDownController _CDController;

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
    _dataFuture = SQLHelper.getSingleData(widget.id);
    _CDController = CountDownController();
    _dataFuture?.then((value) {
      final data = value.isNotEmpty ? value[0] : {};
      setState(() {
        _title = data['title'] ?? '';
        _description = data['description'] ?? '';
        _timer = data['timer'] ?? 0;
        _rest = data['rest'] ?? 0;
        _interval = data['interval'] ?? 0;

        TimerJobs timerJobs = TimerJobs(
          title: _title,
          description: _description,
          timer: _timer,
          rest: _rest,
          interval: _interval,
        );

        _CDController.pause();
        _jobsTimer = timerJobs.generateJobsTimer();
      });
    });
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
        title: "TimeMinder",
        body: message,
        fln: flutterLocalNotificationsPlugin);
  }

  void _queueTimerJob() {
    if (_currentJobIndex < _jobsTimer.length - 1) {
      setState(() {
        _CDController.restart(
          //dummy? data rest gamasuk
          duration: _jobsTimer[_currentJobIndex + 1].duration * 120,
        );
        _currentJobIndex++;
      });
    } else if (_currentJobIndex == _jobsTimer.length - 1) {
      player.play(AssetSource('sounds/end.wav'));
      _showNotification("Timer selesai");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
      // TODO: Add Alert Info for Timer Finish
    }
  }

  String customDescription(String type, int duration) {
    return 'Saat ini sedang $type selama $duration menit';
  }

  final player = AudioPlayer();
  bool _isSoundPlayed = false;

  void _pauseOrResume() {
    if (_CDController.isPaused) {
      setState(() {
        _CDController.resume();
        _showNotification("Timer lanjut");
        if (!_isSoundPlayed) {
          player.play(AssetSource("sounds/start.wav"));
          _isSoundPlayed = true;
        }
      });
    } else {
      setState(() {
        _CDController.pause();
        _showNotification("Timer jeda");
        if (_isSoundPlayed) {
          player.play(AssetSource("sounds/pause.wav"));
          _isSoundPlayed = false;
        }
      });
    }
  }

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ModalConfirm();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _showPopup();
            },
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 30,
              height: 30,
            ),
          ),
          title: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _title,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w600,
                  color: cetaceanBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _description,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          toolbarHeight: 80,
        ),
        body: Center(
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: offYellow,
                        border: Border.all(
                          color: ripeMango,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        _jobsTimer[_currentJobIndex].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      customDescription(
                        _jobsTimer[_currentJobIndex].type,
                        _jobsTimer[_currentJobIndex].duration,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CircularCountDownTimer(
                      //data timer from database
                      duration: inTimeBreak,

                      //dummy timer? data timer gamasuk
                      // duration: _jobsTimer[_currentJobIndex].duration * 60,
                      initialDuration: 0,
                      controller: _CDController,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.5,
                      ringColor: ring,
                      fillColor: _CDController.isPaused ? red : ripeMango,
                      fillGradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          _CDController.isPaused ? red : ripeMango,
                          offOrange
                        ],
                      ),
                      strokeWidth: 20.0,
                      textStyle: const TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      isReverse: true,
                      isReverseAnimation: false,
                      isTimerTextShown: true,
                      onComplete: () {
                        player.play(AssetSource('sounds/end.wav'));
                        _showNotification("Timer selesai");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      onStart: () {
                        player.play(AssetSource('sounds/end.wav'));
                        _showNotification("Timer dimulai");
                        _isSoundPlayed = true;
                      },
                    ),
                    const SizedBox(height: 20),
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
                            ElevatedButton(
                              onPressed: () {
                                _queueTimerJob();
                              },
                              child: const Icon(
                                Icons.skip_next,
                                color: blueJeans,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15),
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
                              onTap: _pauseOrResume,
                              child: SvgPicture.asset(
                                _CDController.isPaused
                                    ? "assets/images/play.svg"
                                    : "assets/images/pause.svg",
                                width: MediaQuery.of(context).size.width * 0.07,
                                height:
                                    MediaQuery.of(context).size.width * 0.07,
                                color: blueJeans,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15),
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
                                height:
                                    MediaQuery.of(context).size.width * 0.07,
                                color: blueJeans,
                              ),
                              color: blueJeans,
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
                          _showNotification("Timer dihentikan");
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
}
