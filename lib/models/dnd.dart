import 'dart:async';
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/pages/detail_custom_timer.dart';

// class FlutterDnd{
//   static const INTERRUPTION_FILTER_NONE=1;
//   static const INTERRUPTION_FILTER_ALL= 2;

//   static Future<int?> getCurrentInterruptionFilter() async{
//     return INTERRUPTION_FILTER_NONE;
//   }

//   static Future<bool?> getisNotificationPolicyAccessGranted() async{
//     return true;
//   }

//   static Future<void> setInterruptionFilter(int filter) async{
//     print("Set filter to: $filter");
//   }

//   static void gotoPolicySettings(){
//     print("Open policy settings");
//   }

//   static String getFilterName(int filter){
//     if(filter==INTERRUPTION_FILTER_NONE){
//       return 'None';
//     }else{
//       return "All";
//     }
//     return '';
//   }
// }

void enableDNdMode() async{
  await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
}

void disableDndMode() async{
  await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
}