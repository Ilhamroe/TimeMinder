import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class SettingBreakWidget extends StatefulWidget {
  final bool statusSwitch;
  final ValueChanged<int>? onBreakTimeChanged;
  final ValueChanged<int>? onIntervalChanged;

  const SettingBreakWidget({
    Key? key,
    required this.statusSwitch,
    this.onBreakTimeChanged,
    this.onIntervalChanged,
  }) : super(key: key);

  @override
  SettingBreakWidgetState createState() => SettingBreakWidgetState();
}

class SettingBreakWidgetState extends State<SettingBreakWidget> {
  int _counterBreakTime = 0;
  int _counterInterval = 0;

  void _increment1() {
    setState(() {
      if (widget.statusSwitch) _counterBreakTime++;
      widget.onBreakTimeChanged?.call(_counterBreakTime);
    });
  }

  void _decrement1() {
    setState(() {
      if (widget.statusSwitch && _counterBreakTime > 0) _counterBreakTime--;
      widget.onBreakTimeChanged?.call(_counterBreakTime);
    });
  }

  void _increment2() {
    setState(() {
      if (widget.statusSwitch) _counterInterval++;
      widget.onIntervalChanged?.call(_counterInterval);
    });
  }

  void _decrement2() {
    setState(() {
      if (widget.statusSwitch && _counterInterval > 0) _counterInterval--;
      widget.onIntervalChanged?.call(_counterInterval);
    });
  }

   void resetCounter() {
    setState(() {
      _counterBreakTime = 0;
      _counterInterval = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.statusSwitch
                  ? offYellow
                  : offGrey,
              border: Border.all(
                color:
                    widget.statusSwitch ? ripeMango : halfGrey,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement1 : null,
                    icon: Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : Color(0xFF838589),
                  ),
                ),
                Expanded(
                  child: Text(
                    '$_counterBreakTime',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF838589),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment1 : null,
                    icon: Icon(Icons.add),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : Color(0xFF838589),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget.statusSwitch
                  ? offYellow
                  : offGrey,
              border: Border.all(
                color:
                    widget.statusSwitch ? ripeMango : halfGrey,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement2 : null,
                    icon: Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : Color(0xFF838589),
                  ),
                ),
                Expanded(
                  child: Text(
                    '$_counterInterval',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF838589),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment2 : null,
                    icon: Icon(Icons.add),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : Color(0xFF838589),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}