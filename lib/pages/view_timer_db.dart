// import 'dart:async';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:mobile_time_minder/database/db_helper.dart';
// import 'package:mobile_time_minder/models/notif.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:mobile_time_minder/theme.dart';
// import 'package:mobile_time_minder/pages/home_page.dart';
// import 'package:mobile_time_minder/widgets/modal_confim.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class DetailTimer extends StatefulWidget {
//   final Map<String, dynamic> data;

//   const DetailTimer({Key? key, required this.data}) : super(key: key);

//   @override
//   State<DetailTimer> createState() => _DetailTimerState();
// }

// class _DetailTimerState extends State<DetailTimer> {
//   bool isRestTime = false;
//   int _counter = 0;
//   int _counterBreakTime = 0;
//   int _counterInterval = 0;
//   int currentTimerValue = 0;
//   bool _isLoading = false;

//   bool _isTimerRunning = false;
//   bool statusSwitch = false;
//   bool hideContainer = true;
//   late List<Map<String, dynamic>> _allData = [];
//   late CountDownController _controller;
//   final player = AudioPlayer();
//   bool _isSoundPlayed = false;

//   int get inTimeMinutes => widget.data['timer'];

//   int get inRestMinutes => widget.data['rest'] ?? 0;

//   int get interval => widget.data['interval'] ?? 1;

//   int get inTimeSeconds => inTimeMinutes * 60;

//   int get inRestSeconds => inRestMinutes * 60;

//   int get inTimeBreak {
//     if (inRestMinutes == 0 && interval == 1) {
//       return inTimeSeconds;
//     } else if (inRestMinutes > 0 && interval == 1) {
//       return inTimeSeconds + inRestSeconds;
//     } else if (inRestMinutes > 0 && interval > 1) {
//       return inTimeSeconds + (inRestSeconds * interval);
//     } else {
//       return inTimeSeconds;
//     }
//   }

//   Map<String, int> getAllMode(
//       int inTimeMinutes, int inRestMinutes, int interval) {
//     int inTimeSeconds = inTimeMinutes * 60;
//     int inRestSeconds = inRestMinutes * 60;

//     int totalDuration = inTimeSeconds + (interval * inRestSeconds);
//     int workDuration = inTimeSeconds ~/ (interval + 1);
//     int remainingWorkDuration = inTimeSeconds - (workDuration * interval);

//     Map<String, int> modeMap = {};
//     for (int i = 0; i < interval; i++) {
//       modeMap['workDuration${i + 1}'] = workDuration;
//       modeMap['restDuration${i + 1}'] = inRestSeconds;
//     }

//     modeMap['workDuration${interval + 1}'] = remainingWorkDuration;

//     return modeMap;
//   }

//   List<Timer> activeTimers = [];

//   void cancelNotifications() {
//     for (Timer timer in activeTimers) {
//       timer.cancel();
//     }
//     activeTimers.clear();
//   }

//   void scheduleNotification(
//       Duration duration, String message, bool isEndOfBreak) {
//     Timer timer = Timer(duration, () {
//       _showNotification(message);
//       if (isEndOfBreak) {
//         player.play(AssetSource('sounds/end.wav'));
//       } else {
//         player.play(AssetSource('sounds/start.wav'));
//       }
//     });
//     activeTimers.add(timer);
//   }

//   void _showNotification(String message) {
//     Notif.showBigTextNotification(
//       title: "TimeMinder",
//       body: message,
//       fln: flutterLocalNotificationsPlugin,
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//     _controller = CountDownController();
//     Notif.initialize(flutterLocalNotificationsPlugin);
//     player.onPlayerComplete.listen((event) {
//       setState(() {
//         _isSoundPlayed = false;
//       });
//     });
//   }

//   void _refreshData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     final data = await SQLHelper.getAllData();
//     setState(() {
//       _allData = data;
//       _isLoading = false;
//     });
//   }

//   void resumeTimer() {
//     setState(() {
//       _controller.resume();
//       _isTimerRunning = false;
//       _showNotification("Timer dilanjutkan");
//       if (!_isSoundPlayed) {
//         player.play(AssetSource("sounds/start.wav"));
//         _isSoundPlayed = true;
//       }
//     });
//   }

//   void pauseTimer() {
//     setState(() {
//       _controller.pause();
//       _isTimerRunning = true;
//       _showNotification("Timer dijeda");
//       if (_isSoundPlayed) {
//         player.play(AssetSource("sounds/pause.wav"));
//         _isSoundPlayed = false;
//       }
//     });

//     @override
//     void dispose() {
//       player.dispose();
//       super.dispose();
//     }

//     @override
//     Widget build(BuildContext context) {
//       final Map<String, dynamic> data = widget.data;

//       return WillPopScope(
//         onWillPop: () => _onBackButtonPressed(context),
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 _showPopup();
//               },
//               icon: SvgPicture.asset(
//                 "assets/images/button_back.svg",
//                 width: 30,
//                 height: 30,
//                 color: cetaceanBlue,
//               ),
//             ),
//             title: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Text(
//                   data['title'],
//                   style: const TextStyle(
//                     fontFamily: 'Nunito-Bold',
//                     fontWeight: FontWeight.w600,
//                     color: cetaceanBlue,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   data['description'],
//                   style: const TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 14,
//                     color: Colors.black,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//               ],
//             ),
//             centerTitle: true,
//             backgroundColor: pureWhite,
//             toolbarHeight: 80,
//           ),
//           body: SafeArea(
//             child: DecoratedBox(
//               decoration: const BoxDecoration(
//                 color: pureWhite,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   CircularCountDownTimer(
//                     duration: getAllMode(inTimeMinutes, inRestMinutes, interval)
//                         .values
//                         .reduce((a, b) => a + b),
//                     initialDuration: 0,
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.height * 0.4,
//                     controller: _controller,
//                     ringColor: ring,
//                     fillColor: _controller.isPaused ? red : ripeMango,
//                     fillGradient: LinearGradient(
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.topRight,
//                       colors: _controller.isPaused
//                           ? [red, offOrange]
//                           : [ripeMango, offOrange],
//                     ),
//                     strokeWidth: 20.0,
//                     isReverse: true,
//                     isReverseAnimation: false,
//                     strokeCap: StrokeCap.round,
//                     autoStart: true,
//                     textStyle: TextStyle(
//                       fontSize: MediaQuery.of(context).size.width * 0.1,
//                       color: _controller.isPaused ? red : cetaceanBlue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     onChange: (String timeStamp) {},
//                     onComplete: () {
//                       player.play(AssetSource('sounds/end.wav'));
//                       _showNotification("Timer Selesai");
//                       _refreshData();
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const HomePage(),
//                         ),
//                       );
//                     },
//                     onStart: () {
//                       player.play(AssetSource('sounds/end.wav'));
//                       _showNotification("Timer dimulai");
//                       _isSoundPlayed = true;
//                       for (int i = 0; i < interval; i++) {
//                         int workDuration = getAllMode(inTimeMinutes!,
//                             inRestMinutes!, interval)['workDuration${i + 1}']!;
//                         int restDuration = getAllMode(inTimeMinutes!,
//                             inRestMinutes!, interval)['restDuration${i + 1}']!;
//                         scheduleNotification(Duration(seconds: workDuration),
//                             "Waktunya Istirahat", false);
//                         scheduleNotification(
//                             Duration(seconds: workDuration + restDuration),
//                             "Istirahat Selesai",
//                             true);
//                       }
//                     },
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.15,
//                             height: MediaQuery.of(context).size.width * 0.15,
//                             decoration: BoxDecoration(
//                               color: offBlue,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: _isTimerRunning ? resumeTimer : pauseTimer,
//                             child: SvgPicture.asset(
//                               _isTimerRunning
//                                   ? "assets/images/play.svg"
//                                   : "assets/images/pause.svg",
//                               width: MediaQuery.of(context).size.width * 0.07,
//                               height: MediaQuery.of(context).size.width * 0.07,
//                               color: blueJeans,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(width: MediaQuery.of(context).size.width * 0.2),
//                       Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.15,
//                             height: MediaQuery.of(context).size.width * 0.15,
//                             decoration: BoxDecoration(
//                               color: offBlue,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return AlertDialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     content: SizedBox(
//                                       width: MediaQuery.of(context).size.width *
//                                           0.68,
//                                       height:
//                                           MediaQuery.of(context).size.height *
//                                               0.42,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           SizedBox(
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.2,
//                                             child: Image.asset(
//                                               'assets/images/confirm_popup.png',
//                                               fit: BoxFit.contain,
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.2,
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.2,
//                                             ),
//                                           ),
//                                           const Text(
//                                             "Timer akan dihapus,",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontFamily: 'Nunito',
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20.0),
//                                           const Text(
//                                             "Apakah Anda yakin?",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontFamily: 'Nunito',
//                                               fontSize: 21,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20.0),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10.0),
//                                                   color: halfGrey,
//                                                 ),
//                                                 child: TextButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context).pop();
//                                                   },
//                                                   child: const Text(
//                                                     "Tidak",
//                                                     style: TextStyle(
//                                                         color: offGrey),
//                                                   ),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 30),
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10.0),
//                                                   color: ripeMango,
//                                                 ),
//                                                 child: TextButton(
//                                                   onPressed: () {
//                                                     cancelNotifications();
//                                                     _showNotification(
//                                                         "Timer dihentikan");
//                                                     _refreshData();
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder: (context) =>
//                                                             HomePage(),
//                                                       ),
//                                                     );
//                                                   },
//                                                   child: const Text(
//                                                     "Ya",
//                                                     style: TextStyle(
//                                                         color: offGrey),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             icon: SvgPicture.asset(
//                               "assets/images/check.svg",
//                               width: MediaQuery.of(context).size.width * 0.07,
//                               height: MediaQuery.of(context).size.width * 0.07,
//                               color: blueJeans,
//                             ),
//                             color: blueJeans,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//   }

//   Future<bool> _onBackButtonPressed(BuildContext context) async {
//     bool? exitApp = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           content: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.68,
//             height: MediaQuery.of(context).size.height * 0.42,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.2,
//                   child: Image.asset(
//                     'assets/images/confirm_popup.png',
//                     fit: BoxFit.contain,
//                     width: MediaQuery.of(context).size.width * 0.2,
//                     height: MediaQuery.of(context).size.width * 0.2,
//                   ),
//                 ),
//                 const Text(
//                   "Kembali ke Beranda,",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 15,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 const Text(
//                   "Apakah Anda yakin?",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontFamily: 'Nunito',
//                     fontSize: 21,
//                   ),
//                 ),
//                 const SizedBox(height: 20.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: halfGrey,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(false);
//                         },
//                         child: const Text(
//                           "Tidak",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 30),
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                         color: ripeMango,
//                       ),
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => HomePage(),
//                             ),
//                           );
//                           cancelNotifications();
//                         },
//                         child: const Text(
//                           "Ya",
//                           style: TextStyle(color: offGrey),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );

//     return exitApp ?? false;
//   }

//   void _showPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return const ModalConfirm();
//       },
//     );
//   }
// }
