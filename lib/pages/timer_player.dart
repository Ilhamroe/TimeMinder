import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/services/timer_jobs.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/timer_finish_dialog.dart';

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

  @override
  void initState() {
    super.initState();
    _dataFuture = SQLHelper.getSingleData(widget.id);
    _currentJobIndex = 0;
    _title = '';
    _description = '';
    _timer = 0;
    _rest = 0;
    _interval = 0;
    _jobsTimer = [];
    _cDController.pause();
    _dataFuture.then((value) {
      final data = value.isNotEmpty ? value[0] : {};
      setState(() {
        _title = data['title'] ?? '';
        _description = data['description'] ?? '';
        _timer = data['timer'] ?? 0;
        _rest = data['rest'] ?? 0;
        _interval = data['interval'] ?? 0;
        final timerJobs = TimerJobs(
          title: _title,
          description: _description,
          timer: _timer,
          rest: _rest,
          interval: _interval,
        );
        _jobsTimer = timerJobs.generateJobsTimer();
      });
    });
  }

  void _queueTimerJob() {
    if (_currentJobIndex < _jobsTimer.length - 1) {
      setState(() {
        _cDController.restart(
            duration: _jobsTimer[++_currentJobIndex].duration * 60);
        if (_jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
          _player.play(AssetSource('sounds/start.wav'));
          _showNotification("Waktunya Istirahat");
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
              return AlertDialog(
                title: const Text(
                  'Istirahat',
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/cat_hello.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Waktunya istirahat',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _cDController.resume();
                      Navigator.pop(context);
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        }
        if (_jobsTimer[_currentJobIndex].type == 'FOKUS') {
          _player.play(AssetSource('sounds/pause.wav'));
          _showNotification("Istirahat Selesai");
          showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });
              return AlertDialog(
                title: const Text(
                  'Istirahat',
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/cat_hello.png',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.width * 0.2,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Istirahat Selesai',
                      style: TextStyle(fontSize: 19),
                    )
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _cDController.resume();
                      Navigator.pop(context);
                    },
                    child: const Text('Oke'),
                  ),
                ],
              );
            },
          );
        }
      });
    } else {
      _player.play(AssetSource('sounds/end.wav'));
      _showNotification("Timer Selesai");
      _cDController.pause();
      Navigator.pop(context);
    }
  }

  void _showNotification(String message) {
    Notif.showBigTextNotification(
      title: "TimeMinder",
      body: message,
      fln: flutterLocalNotificationsPlugin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => TimerFinishDialog(
                  onEndTimer: () {
                    _clearJobs();
                    Navigator.pop(context);
                  },
                ),
              );
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
                  color: cetaceanBlue,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          toolbarHeight: 80,
        ),
        body: WillPopScope(
          onWillPop: () async {
            final shouldPop = await showDialog(
              context: context,
              builder: (context) => TimerFinishDialog(
                onEndTimer: () {
                  _clearJobs();
                  Navigator.pop(context);
                },
              ),
            );

            return shouldPop ?? false;
          },
          child: Center(
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
                            color: getColorRing(),
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
                      const SizedBox(height: 20),
                      // Text(
                      //   '${_jobsTimer[_currentJobIndex].duration} menit',
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontFamily: 'Nunito',
                      //     fontSize: 14,
                      //     color: Colors.black,
                      //   ),
                      // ),
                      // const SizedBox(height: 20),
                      CircularCountDownTimer(
                        duration: _jobsTimer[_currentJobIndex].duration * 60,
                        initialDuration: 0,
                        controller: _cDController,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        ringColor: ring,
                        fillColor: getColorRing(),
                        fillGradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            getColorRing(),
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
                        onStart: () {
                          _player.play(AssetSource('sounds/end.wav'));
                          _showNotification("Timer dimulai");
                        },
                        onComplete: () {
                          _queueTimerJob();
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05),
                      // if (_currentJobIndex < _jobsTimer.length - 1)
                      //   Text(
                      //     'Selanjutnya : ${_jobsTimer[_currentJobIndex + 1].type} selama ${_jobsTimer[_currentJobIndex + 1].duration} menit',
                      //     textAlign: TextAlign.center,
                      //     style: const TextStyle(
                      //       fontFamily: 'Nunito',
                      //       fontSize: 12,
                      //       color: darkGrey,
                      //     ),
                      //   )
                      // else
                      //   const Text(
                      //     'Ini adalah sesi terakhir',
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontFamily: 'Nunito',
                      //       fontSize: 12,
                      //       color: darkGrey,
                      //     ),
                      //   ),
                      // const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // ElevatedButton(
                          //   onPressed: () {
                          //     _queueTimerJob();
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: offBlue,
                          //   ),
                          //   child: const Icon(
                          //     Icons.skip_next,
                          //     color: blueJeans,
                          //   ),
                          // ),
                          // const SizedBox(width: 20),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // children: [
                                //   ElevatedButton(
                                //     onPressed: () {
                                //       showDialog(
                                //           context: context,
                                //           builder: (context) => TimerFinishDialog(
                                //                 title: 'Perhatian!',
                                //                 message:
                                //                     'Apakah Anda yakin ingin melewati timer ini?',
                                //                 onEndTimer: () {
                                //                   _queueTimerJob();
                                //                   _showNotification('Timer Dilewati');
                                //                   Navigator.pop(context);
                                //                 },
                                //               ));
                                //     },
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: offBlue,
                                //     ),
                              ),
                              GestureDetector(
                                onTap: _pauseOrResume,
                                child: SvgPicture.asset(
                                  _cDController.isPaused
                                      ? "assets/images/play.svg"
                                      : "assets/images/pause.svg",
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
                                  height:
                                      MediaQuery.of(context).size.width * 0.07,
                                  color: blueJeans,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.15,
                                height:
                                    MediaQuery.of(context).size.width * 0.15,
                                decoration: BoxDecoration(
                                  color: offBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => TimerFinishDialog(
                                      onEndTimer: () {
                                        _clearJobs();
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  "assets/images/check.svg",
                                  width:
                                      MediaQuery.of(context).size.width * 0.07,
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
        ));
  }

  void _pauseOrResume() {
    setState(() {
      if (_cDController.isPaused) {
        _player.play(AssetSource('sounds/start.wav'));
        _cDController.resume();
        _showNotification('Timer dilanjutkan');
      } else {
        _player.play(AssetSource('sounds/pause.wav'));
        _cDController.pause();
        _showNotification('Timer dihentikan');
      }
    });
  }

  Color getColorRing() {
    if (_cDController.isPaused || _jobsTimer[_currentJobIndex].type == 'ISTIRAHAT') {
      return red;
    } else {
      return ripeMango;
    }
  }

  void _clearJobs() {
    setState(() {
      _player.play(AssetSource('sounds/end.wav'));
      _currentJobIndex = 0;
      _cDController.restart(
          duration: _jobsTimer[_currentJobIndex].duration * 60);
      _cDController.pause();
    });
    _showNotification('Timer selesai');
  }
}
