
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:mobile_time_minder/database/db_helper.dart';
// import 'package:mobile_time_minder/services/timer_jobs.dart';
// import 'package:mobile_time_minder/theme.dart';
// import 'package:mobile_time_minder/services/send_notification.dart';
// class TimerPlayer extends StatefulWidget {
//   final int id;

//   const TimerPlayer({super.key, required this.id});

//   @override
//   State<TimerPlayer> createState() => _TimerPlayerState();
// }

// class _TimerPlayerState extends State<TimerPlayer> {
//   Future<List<Map<String, dynamic>>>? _dataFuture;

//   String _title = '';
//   String _description = '';
//   int _timer = 0;
//   int _rest = 0;
//   int _interval = 0;
//   late List<ListJobs> _jobsTimer;
//   int _currentJobIndex = 0;
//   late CountDownController _CDController;

//   @override
//   void initState() {
//     super.initState();
//     _dataFuture = SQLHelper.getSingleData(widget.id);
//     _CDController = CountDownController();
//     _dataFuture?.then((value) {
//       final data = value.isNotEmpty ? value[0] : {};
//       setState(() {
//         _title = data['title'] ?? '';
//         _description = data['description'] ?? '';
//         _timer = data['timer'] ?? 0;
//         _rest = data['rest'] ?? 0;
//         _interval = data['interval'] ?? 0;

//         TimerJobs timerJobs = TimerJobs(
//           title: _title,
//           description: _description,
//           timer: _timer,
//           rest: _rest,
//           interval: _interval,
//         );

//         _CDController.pause();
//         _jobsTimer = timerJobs.generateJobsTimer();
//       });
//     });
//   }

//   void _queueTimerJob() {
//     if (_currentJobIndex < _jobsTimer.length - 1) {
//       setState(() {
//         _CDController.restart(
//           duration: _jobsTimer[_currentJobIndex + 1].duration * 60,
//         );
//         _currentJobIndex++;
//       });
//     } else if (_currentJobIndex == _jobsTimer.length - 1) {
//       SendNotification(
//         body: 'Timer selesai',
//       );

//       // TODO: Add Alert Info for Timer Finish
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: pureWhite,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {},
//           icon: SvgPicture.asset(
//             "assets/images/button_back.svg",
//             width: 30,
//             height: 30,
//           ),
//         ),
//         title: Column(
//           children: [
//             const SizedBox(height: 20),
//             Text(
//               _title,
//               style: const TextStyle(
//                 fontFamily: 'Nunito-Bold',
//                 fontWeight: FontWeight.w600,
//                 color: cetaceanBlue,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               _description,
//               style: const TextStyle(
//                 fontFamily: 'Nunito',
//                 fontSize: 14,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//         centerTitle: true,
//         backgroundColor: pureWhite,
//         toolbarHeight: 80,
//       ),
//       body: Center(
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: _dataFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else {
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: offYellow,
//                       border: Border.all(
//                         color: ripeMango,
//                         width: 1,
//                       ),
//                     ),
//                     child: Text(
//                       _jobsTimer[_currentJobIndex].title,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontFamily: 'Nunito-Bold',
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     customDescription(
//                       _jobsTimer[_currentJobIndex].type,
//                       _jobsTimer[_currentJobIndex].duration,
//                     ),
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(
//                       fontFamily: 'Nunito',
//                       fontSize: 14,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   CircularCountDownTimer(
//                     duration: _jobsTimer[_currentJobIndex].duration * 60,
//                     initialDuration: 0,
//                     controller: _CDController,
//                     width: MediaQuery.of(context).size.width * 0.5,
//                     height: MediaQuery.of(context).size.width * 0.5,
//                     ringColor: ring,
//                     fillColor: _CDController.isPaused ? red : ripeMango,
//                     fillGradient: LinearGradient(
//                       begin: Alignment.bottomLeft,
//                       end: Alignment.topRight,
//                       colors: [
//                         _CDController.isPaused ? red : ripeMango,
//                         offOrange
//                       ],
//                     ),
//                     strokeWidth: 20.0,
//                     textStyle: const TextStyle(
//                       fontSize: 40.0,
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     isReverse: true,
//                     isReverseAnimation: false,
//                     isTimerTextShown: true,
//                     onComplete: () {
//                       _queueTimerJob();
//                     },
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children:[
//                       ElevatedButton(
//                         onPressed: () {
//                           _queueTimerJob();
//                           SendNotification(
//                             body: 'Timer dilewati',
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: offBlue,
//                         ),
//                         child: const Icon(
//                           Icons.skip_next,
//                           color: blueJeans ,
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           _pauseOrResume();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: offBlue,
//                         ),
//                         child: Icon(
//                           _CDController.isPaused ? Icons.play_arrow : Icons.pause,
//                           color: blueJeans,
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: () {

//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: offBlue,
//                         ),
//                         child: const Icon(
//                           Icons.check,
//                           color: blueJeans,
//                         ),
//                       ),
//                     ]
//                   )
//                 ],
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   String customDescription(String type, int duration) {
//     return 'Saat ini sedang $type selama $duration menit';
//   }

//   void _pauseOrResume() {
//     if (_CDController.isPaused) {
//       setState(() {
//         _CDController.resume();
//         SendNotification(
//           body: 'Timer dilanjutkan',
//         );
//       });
//     } else {
//       setState(() {
//         _CDController.pause();
//         SendNotification(
//           body: 'Timer dihentikan',
//         );
//       });
//     }
//   }
// }
