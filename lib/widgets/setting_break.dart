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
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * 0.45;

    return Row(
      children: [
        Expanded(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 4),
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
                IconButton(
                  onPressed: widget.statusSwitch ? _decrement1 : null,
                  icon: const Icon(Icons.remove),
                  iconSize: 16,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
                Flexible(
                  child: TextFormField(
                    initialValue: '$_counterBreakTime',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrey,
                    ),
                    onChanged: (value) {
                      if (widget.statusSwitch) {
                        final newValue = int.tryParse(value) ?? 0;
                        widget.onIntervalChanged?.call(newValue);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.statusSwitch ? _increment1 : null,
                  icon: const Icon(Icons.add),
                  iconSize: 16,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: Container(
            width: containerWidth,
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 4),
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
                IconButton(
                  onPressed: widget.statusSwitch ? _decrement2 : null,
                  icon: const Icon(Icons.remove),
                  iconSize: 16,
                  color: widget.statusSwitch ? ripeMango : darkGrey,
                ),
                Flexible(
                  child: TextFormField(
                    initialValue: '$_counterInterval',
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrey,
                    ),
                    onChanged: (value) {
                      if (widget.statusSwitch) {
                        final newValue = int.tryParse(value) ?? 0;
                        widget.onIntervalChanged?.call(newValue);
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.statusSwitch ? _increment2 : null,
                  icon: const Icon(Icons.add),
                  iconSize: 16,
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
