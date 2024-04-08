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
  late TextEditingController _textBreakController;
  late TextEditingController _textIntervalController;

  void _increment1() {
    setState(() {
      if (widget.statusSwitch) _counterBreakTime++;
      widget.onBreakTimeChanged?.call(_counterBreakTime);
      _textBreakController.text = _counterBreakTime.toString();
    });
  }

  void _decrement1() {
    setState(() {
      if (widget.statusSwitch && _counterBreakTime > 0) _counterBreakTime--;
      widget.onBreakTimeChanged?.call(_counterBreakTime);
      _textBreakController.text = _counterBreakTime.toString();
    });
  }

  void _increment2() {
    setState(() {
      if (widget.statusSwitch) _counterInterval++;
      widget.onIntervalChanged?.call(_counterInterval);
      _textIntervalController.text = _counterInterval.toString();
    });
  }

  void _decrement2() {
    setState(() {
      if (widget.statusSwitch && _counterInterval > 0) _counterInterval--;
      widget.onIntervalChanged?.call(_counterInterval);
      _textIntervalController.text = _counterInterval.toString();
    });
  }

  void resetCounter() {
    setState(() {
      _counterBreakTime = 0;
      _counterInterval = 0;
      _textBreakController.text = _counterBreakTime.toString();
      _textIntervalController.text = _counterInterval.toString();
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
              color: widget.statusSwitch ? offYellow : offGrey,
              border: Border.all(
                color: widget.statusSwitch ? ripeMango : halfGrey,
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
                        color: offYellow,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement1 : null,
                    icon: Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: Text(
                    '$_counterBreakTime',
                    style: TextStyle(
                      fontSize: 12,
                      color: darkGrey,
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
                    color: widget.statusSwitch ? ripeMango : darkGrey,
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
              color: widget.statusSwitch ? offYellow : offGrey,
              border: Border.all(
                color: widget.statusSwitch ? ripeMango : halfGrey,
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
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: Text(
                    '$_counterInterval',
                    style: TextStyle(
                      fontSize: 12,
                      color: darkGrey,
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
                    color: widget.statusSwitch ? ripeMango : darkGrey,
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
