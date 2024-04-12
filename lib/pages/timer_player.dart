import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/services/timer_jobs.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:audioplayers/audioplayers.dart';

class CombinedTimerPage extends StatefulWidget {
  final int id;

  const CombinedTimerPage({Key? key, required this.id}) : super(key: key);

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
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
      });
    } else {
      _showNotification('Timer Selesai');
      showDialog(
        context: context,
        builder: (context) => TimerFinishDialog(
          onEndTimer: () {
            _clearJobs();
            Navigator.pop(context);
          },
        ),
      );
      _cDController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              TimerFinishDialog(
                onEndTimer: () {
                  _clearJobs();
                  Navigator.pop(context);
                },
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
                  color: ripeMango,
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
                        '${_jobsTimer[_currentJobIndex].duration} menit',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CircularCountDownTimer(
                        duration: _jobsTimer[_currentJobIndex].duration * 60,
                        initialDuration: 0,
                        controller: _cDController,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.width * 0.5,
                        ringColor: ring,
                        fillColor: _cDController.isPaused ? red : ripeMango,
                        fillGradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            _cDController.isPaused ? red : ripeMango,
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
                          _queueTimerJob();
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_currentJobIndex < _jobsTimer.length - 1)
                        Text(
                          'Selanjutnya : ${_jobsTimer[_currentJobIndex + 1].type} selama ${_jobsTimer[_currentJobIndex + 1].duration} menit',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: darkGrey,
                          ),
                        )
                      else
                        const Text(
                          'Ini adalah sesi terakhir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12,
                            color: darkGrey,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _queueTimerJob();
                                _showNotification('Timer Dilewati');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: offBlue,
                              ),
                              child: const Icon(
                                Icons.skip_next,
                                color: blueJeans,
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _pauseOrResume,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: offBlue,
                              ),
                              child: Icon(
                                _cDController.isPaused
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                color: blueJeans,
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
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
                              style: ElevatedButton.styleFrom(
                                backgroundColor: offBlue,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: blueJeans,
                              ),
                            ),
                          ])
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
        _player.play(AssetSource('sounds/end.wav'));
        _cDController.pause();
        _showNotification('Timer dihentikan');
      }
    });
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

  void _showNotification(String message) {
    int generateRandomId() {
      return DateTime.now().millisecondsSinceEpoch.remainder(100000);
    }

    Notif.showBigTextNotification(
      id: generateRandomId(),
      title: "TimeMinder",
      body: message,
      fln: _flutterLocalNotificationsPlugin,
    );
  }
}

class TimerFinishDialog extends StatelessWidget {
  final VoidCallback? onEndTimer;
  final String? title;
  final String? message;

  const TimerFinishDialog(
      {super.key, this.onEndTimer, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Timer Selesai'),
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
          Text(message ?? 'Apakah Anda ingin menyelesaikan'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () {
            onEndTimer?.call();
            Navigator.pop(context);
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
