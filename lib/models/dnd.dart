import 'package:flutter_dnd/flutter_dnd.dart';

Future<void> enableDndMode() async{
  try{
    await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
  }catch (e){
    print("DND tidak aktif");
  }
}

Future<void> disableDndMode() async{
  try{
    await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
  }catch (e){
    print("DND masih aktif");
  }
}