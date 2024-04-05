import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:mobile_time_minder/models/dnd.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:mobile_time_minder/pages/tes.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

class DetailTimer extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailTimer({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTimer> createState() => _DetailTimerState();
}

class _DetailTimerState extends State<DetailTimer> {
  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool _isTimerRunning = false; // Menyimpan status timer
  bool statusSwitch = false;
  bool hideContainer = true;
  late List<Map<String, dynamic>> _allData = [];
  late CountdownController _controller; // Controller untuk Countdown widget
  final player= AudioPlayer();
  bool _isSoundPlayed= false;
  // String _filtername= '';
  // bool? isNotificationAccessGranted = false;
  // bool? isDNDActive= false;

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
    _controller = CountdownController();
    Notif.initialize(flutterLocalNotificationsPlugin);
    // FlutterDnd.initialize();
    // WidgetsBinding.instance!.addObserver(this);
    // updateUI();
  }

  // void updateUI() async{
  //   int? filter= await FlutterDnd.getCurrentInterruptionFilter();
  //   if(filter != null){
  //     String filtername= FlutterDnd.getFilterName(filter);
  //     bool? isNotificationAccessGranted= 
  //       await FlutterDnd.isNotificationPolicyAccessGranted;
  //   }
  // }

  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });
  }
    void _showNotification(String message){
    Notif.showBigTextNotification(
      title: "TimeMinder", 
      body: message, 
      fln: flutterLocalNotificationsPlugin
      );
  }

    void _handleDndMode() async {
      if(!_isTimerRunning){
        if(!_isDndEnabled()){
          enableDNdMode();
        }else{
          disableDndMode();
        }
      }
    }

    bool _isDndEnabled(){
      return false;
    }

  // Future<void> _playNotificationSound(String soundPath) async{

  // }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data['description']),
            SizedBox(height: 20),
            Countdown(
              controller: _controller,
              seconds: inTimeBreak,
              build: (_, double time) => Text(
                'Time left: ${time.toInt()}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              onFinished: () {
                setState(() {
                  _isTimerRunning = false;
                  _showNotification("Timer selesai");
                 
                  player.play(AssetSource('sounds/end.wav'));
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_isTimerRunning){  
                  _controller.pause();
                  _showNotification("Timer dijeda");
                 disableDndMode();
                  if(!_isSoundPlayed){
                    player.stop();
                  }
                  player.play(AssetSource('sounds/pause.wav'));   
                  _isSoundPlayed= false;                            
                }else{
                  _controller.start();
                  _showNotification("Timer dimulai");
                 enableDNdMode();
                 

                  if(!_isSoundPlayed){
                    // player.stop();
                    player.play(AssetSource('sounds/start.wav'));
                  _isSoundPlayed= true; 
                  }
                                         
                }
                _toggleTimer();
              },
              child: Text(_isTimerRunning ? 'Pause' : 'Play'),
            ),
            SizedBox(height: 20),
            Text("Timer: ${data['timer']}"),
            Text("Rest: ${data['rest']}"),
            Text("Interval: ${data['interval']}"),
          ],
        ),
      ),
    );
  }
}