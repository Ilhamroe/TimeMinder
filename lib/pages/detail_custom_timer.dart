import 'package:flutter/cupertino.dart';
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
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();


class DetailTimer extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailTimer({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailTimer> createState() => _DetailTimerState();
}

class _DetailTimerState extends State<DetailTimer> {
  bool _isLoading = false;
  bool _isTimerRunning = false; // Menyimpan status timer
  bool statusSwitch = false;
  bool hideContainer = true;
  late List<Map<String, dynamic>> _allData = [];
  late CountDownController _controller; // Controller untuk Countdown widget
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
    _controller = CountDownController();
    Notif.initialize(flutterLocalNotificationsPlugin);
    player.onPlayerComplete.listen((event) {
      setState(() {
        _isSoundPlayed= false;
      });
    });
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
              data['title'],
              style: TextStyle(
                fontFamily: 'Nunito-Bold',
                fontWeight: FontWeight.w600,
                color: cetaceanBlue,
              ),
            textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              data['description'],
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: Colors.black,
              ),
           ),

            //   onFinished: () {
            //     setState(() {
            //       _isTimerRunning = false;
            //       _showNotification("Timer selesai");
                 
            //       player.play(AssetSource('sounds/end.wav'));
            //     });
            //   },
            // ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () {
            //     if(_isTimerRunning){  
            //       _controller.pause();
            //       _showNotification("Timer dijeda");
            //      disableDndMode();
            //       if(!_isSoundPlayed){
            //         player.stop();
            //       }
            //       player.play(AssetSource('sounds/pause.wav'));   
            //       _isSoundPlayed= false;                            
            //     }else{
            //       _controller.start();
            //       _showNotification("Timer dimulai");
            //      enableDNdMode();
                 

            //       if(!_isSoundPlayed){
            //         // player.stop();
            //         player.play(AssetSource('sounds/start.wav'));
            //       _isSoundPlayed= true; 
            //       }
                                         
            //     }
            //     _toggleTimer();
            //   },
            //   child: Text(_isTimerRunning ? 'Pause' : 'Play'),

  
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
                  duration: inTimeBreak,
                  initialDuration: 0,
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height / 2,
                  controller:_controller,
                  ringColor: offGrey,
                  fillColor: _controller.isPaused ? red : ripeMango,
                  strokeWidth: 20.0,
                  isReverse: true,
                  isReverseAnimation: true,
                  strokeCap: StrokeCap.round,
                  autoStart: true,
                  textStyle: TextStyle(
                    fontSize: 33.0,
                    color: _controller.isPaused ? red : red,
                    fontWeight: FontWeight.bold,
                  ),
                  onStart: () {
                    _showNotification("Timer dimulai");
                    player.play(AssetSource('sounds/end.wav'));
                    _isSoundPlayed= true;
                  },
                  onComplete: () {
                  _showNotification("Timer selesai");
                  player.play(AssetSource('sounds/end.wav'));
                    _showPopup();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (_isTimerRunning)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.resume();
                            _showNotification("Timer dimulai");
                            _isTimerRunning = false;

                                                         
                            player.play(AssetSource('sounds/start.wav'));
                               _isSoundPlayed= true;  
                             player.stop();     
                                              
                                                                
                          });
                        },
                        child: Icon(
                          Icons.play_arrow_outlined,
                          color: blueJeans,
                          size: 40,
                        ),
                      ),
                    if (!_isTimerRunning)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.pause();
                            _isTimerRunning = true;
                            _showNotification("Timer dijeda"); 
                                                      
                            player.stop();
                            player.play(AssetSource('sounds/pause.wav'));
                            _isSoundPlayed= false;  
                       
                            
                                       
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

  void _showPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalConfirm();
      },
    );
  }
}
