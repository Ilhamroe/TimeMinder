import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/utils/colors.dart';

class SettingBreakWidget extends StatefulWidget {
  final bool statusSwitch;
  final ValueChanged<int>? onBreakTimeChanged;
  final ValueChanged<int>? onIntervalChanged;
  final int initialBreakTime;
  final int initialInterval;

  const SettingBreakWidget({
    super.key,
    required this.statusSwitch,
    this.onBreakTimeChanged,
    this.onIntervalChanged,
    required this.initialBreakTime,
    required this.initialInterval,
  });

  @override
  SettingBreakWidgetState createState() => SettingBreakWidgetState();
}

class SettingBreakWidgetState extends State<SettingBreakWidget> {
  bool statusSwitch = false;
  int counterBreakTime = 0;
  int counterInterval = 0;
  TextEditingController breakTimeController = TextEditingController();
  TextEditingController intervalController = TextEditingController();
  TextEditingController breakTimeEmptyController = TextEditingController();
  TextEditingController intervalEmptyController = TextEditingController();

  @override
  void dispose() {
    breakTimeController.dispose();
    intervalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    statusSwitch= widget.statusSwitch;
    counterBreakTime = widget.initialBreakTime;
    counterInterval = widget.initialInterval;
    breakTimeController =
        TextEditingController(text: counterBreakTime.toString());
    intervalController =
        TextEditingController(text: counterInterval.toString());
    breakTimeEmptyController = TextEditingController(text: '0');
    intervalEmptyController = TextEditingController(text: '0');
    print("SETSTATE");
  }

  void _onBreakTimeChanged(String value) {
    final newBreakTime = breakTimeController.text;
    debugPrint('KETIKA DIPENCET: $newBreakTime');
    if(newBreakTime.isEmpty){
      setState(() {
        counterBreakTime = 0;
        breakTimeController.text= '0';
        breakTimeController.selection= const TextSelection.collapsed(offset: 1);
      });
      widget.onBreakTimeChanged?.call(counterBreakTime);
  }else{
    final newValue2= int.tryParse(newBreakTime);
    if(newValue2 != null){
      setState(() {
        counterBreakTime= newValue2;
        breakTimeController.value= TextEditingValue(
          text: counterBreakTime.toString(),
          selection: TextSelection.collapsed(offset: counterBreakTime.toString().length),
        );
      });
      widget.onBreakTimeChanged?.call(counterBreakTime);
    }
  }
  debugPrint('KETIKA ga ngap ngapa: $counterBreakTime');
}

  void _onIntervalChanged(String value) {
    final newInterval= intervalController.text;
    if(newInterval.isEmpty){
      setState(() {
        counterInterval = 0;
        intervalController.text= '0';
        intervalController.selection= const TextSelection.collapsed(offset: 1);
      });
      widget.onIntervalChanged?.call(counterInterval);
    }else{
      final newValue= int.tryParse(newInterval);
      if(newValue != null){
        setState(() {
          counterInterval= newValue;
          intervalController.value= TextEditingValue(
            text: counterInterval.toString(),
            selection: TextSelection.collapsed(offset: counterInterval.toString().length),
          );
        });
        widget.onIntervalChanged?.call(counterInterval);
      }
    }
  }

  void resetCounter() {
    setState(() {
      counterBreakTime = 0;
      counterInterval = 0;
    });
  }

  void setBreakTimeCounter(int value) {
    setState(() {
      counterBreakTime = value;
      breakTimeController.text = value.toString();
    });
  }

  void setIntervalCounter(int value) {
    setState(() {
      counterInterval = value;
      intervalController.text = value.toString();
    });
  }

  void _incrementBreakTime() {
    setState(() {
      counterBreakTime++;
      breakTimeController.text = counterBreakTime.toString();
    });
    debugPrint('KETIKA DIPENCET: $counterBreakTime');
    widget.onBreakTimeChanged?.call(counterBreakTime);
  }
  
  void _incrementInterval() {
    setState(() {
      counterInterval++;
      intervalController.text = counterInterval.toString();
    });
    widget.onIntervalChanged?.call(counterInterval);
  }

  void _decrementBreakTime() {
    if (counterBreakTime > 0) {
      setState(() {
        counterBreakTime--;
        breakTimeController.text = counterBreakTime.toString();
      });
      widget.onBreakTimeChanged?.call(counterBreakTime);
    }
  }

  void _decrementInterval() {
    if (counterInterval > 0) {
      setState(() {
        counterInterval--;
        intervalController.text = counterInterval.toString();
      });
      widget.onIntervalChanged?.call(counterInterval);
    }
  }

  // void _offSwitch(){
  //   setState(() {
  //     counterBreakTime= 0;
  //     counterInterval= 0;
  //     breakTimeController.text= '0';
  //     intervalController.text= '0';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2).w,
            margin: const EdgeInsets.only(right: 4).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15).w,
              color: widget.statusSwitch ? offYellow : offGrey,
              border: Border.all(
                color: widget.statusSwitch ? ripeMango : halfGrey,
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.statusSwitch
                      ? _decrementBreakTime
                      : null,
                  icon: const Icon(Icons.remove),
                  iconSize: 16.h,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
                Expanded(
                  child: widget.statusSwitch
                      ? TextFormField(
                          controller: breakTimeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onChanged: _onBreakTimeChanged,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: darkGrey,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : TextFormField(
                          controller: breakTimeEmptyController,                        
                          enabled: false,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: darkGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
                IconButton(
                  onPressed: widget.statusSwitch
                      ? _incrementBreakTime
                      : null,
                  icon: const Icon(Icons.add),
                  iconSize: 16.h,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2).w,
            margin: const EdgeInsets.only(right: 4).w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.statusSwitch ? offYellow : offGrey,
              border: Border.all(
                color: widget.statusSwitch ? ripeMango : halfGrey,
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.statusSwitch
                      ? _decrementInterval
                      : null,
                  icon: const Icon(Icons.remove),
                  iconSize: 16.h,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
                Expanded(
                    child: widget.statusSwitch
                        ? TextFormField(
                            controller: intervalController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: _onIntervalChanged,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: darkGrey,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : TextFormField(
                            controller: intervalEmptyController,
                            enabled: false,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: _onIntervalChanged,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: darkGrey,
                            ),
                            textAlign: TextAlign.center,
                          )),
                IconButton(
                  onPressed: widget.statusSwitch
                      ? _incrementInterval
                      : null,
                  icon: const Icon(Icons.add),
                  iconSize: 16.h,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
