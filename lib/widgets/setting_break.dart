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

  @override
  void initState() {
    super.initState();
    _textBreakController =
        TextEditingController(text: _counterBreakTime.toString());
    _textIntervalController =
        TextEditingController(text: _counterInterval.toString());
  }

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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.01),
            margin: EdgeInsets.only(
                right: screenWidth * 0.03, left: screenWidth * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement1 : null,
                    icon: Icon(Icons.remove),
                    iconSize: screenWidth * 0.04,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _textBreakController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: darkGrey,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment1 : null,
                    icon: Icon(Icons.add),
                    iconSize: screenWidth * 0.04,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.005),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(screenWidth * 0.01),
            margin: EdgeInsets.only(
                right: screenWidth * 0.03, left: screenWidth * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement2 : null,
                    icon: Icon(Icons.remove),
                    iconSize: screenWidth * 0.04,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _textIntervalController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: darkGrey,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment2 : null,
                    icon: Icon(Icons.add),
                    iconSize: screenWidth * 0.04,
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
