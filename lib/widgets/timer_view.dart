import 'package:flutter/material.dart';
import 'package:mobile_time_minder/models/timers.dart';
import 'package:mobile_time_minder/pages/custom_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:sqflite/sqflite.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({super.key});

  @override
  CustomTimerState createState() => CustomTimerState();
}



class TimerView extends StatelessWidget {
  final bool isSettingPressed;

  const TimerView({super.key, required this.isSettingPressed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: timerList.length,
      itemBuilder: (context, index) {
        final timers = timerList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
          decoration: BoxDecoration(
            color: ripeMango.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: heliotrope,
                      ),
                      child: Center(
                        child: ClipPath(
                          child: Image.asset(
                            timers.image,
                            fit: BoxFit.scaleDown,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timers.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            timers.timersDesc,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 40.0, top: 20.0),
                            child: Text(timers.timerEstimate,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!isSettingPressed)
                                IconButton(
                                  iconSize: 20,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  color: blueJeans,
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 10),
                                  icon: const Icon(Icons.edit, size: 15),//Logic edit
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const DisplayModal(); // Menampilkan widget DisplayModal sebagai dialog
                                      },
                                    );
                                  },
                                ),
                              if (!isSettingPressed)
                                IconButton(
                                  iconSize: 20,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  color: radial,
                                  padding: const EdgeInsets.only(
                                      right: 10.0, top: 10),
                                  icon: const Icon(Icons.delete, size: 15),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          content: SizedBox(
                                            width:100,
                                            height:300,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height:120.0,
                                                  child: Image.asset('assets/images/confirm_popup.png',
                                                    fit: BoxFit.contain,
                                                    width: 100,
                                                    height:100,
                                                  ),
                                                ),
                                                const Text(
                                                  "Hapus Timer",
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito-Bold',
                                                    fontSize: 18.0,
                                                    color: radial,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                    height:10.0),
                                                const Text("Apakah Anda yakin?",
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                    height:20.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:80,
                                                      height:40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:BorderRadius.circular(10.0),
                                                        color:halfGrey,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // delete logic here
                                                          deleteData();
                                                        },
                                                        child: const Text("Ya",style: TextStyle(color:Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:30),
                                                    Container(
                                                      width:80,
                                                      height:40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(10.0),
                                                        color:ripeMango,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text("Tidak",style: TextStyle(color:Colors.white),
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
                                  },
                                ),
                              if (isSettingPressed)
                                IconButton(
                                  iconSize: 50,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                                  icon: Image.asset('assets/images/playbutton.png',
                                    fit: BoxFit.contain,
                                    width: 40,
                                    height: 40,
                                  ),
                                  onPressed: () {},
                                ),
                            ],
                          ),
                        ],
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
  void deleteData(){
  }
}

