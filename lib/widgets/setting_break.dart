import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class SettingBreakWidget extends StatefulWidget {
  final bool statusSwitch;
  final ValueChanged<int>? onBreakTimeChanged;
  final ValueChanged<int>? onIntervalChanged;

  const SettingBreakWidget({
    super.key,
    required this.statusSwitch,
    this.onBreakTimeChanged,
    this.onIntervalChanged,
  });

  @override
  SettingBreakWidgetState createState() => SettingBreakWidgetState();
}

class SettingBreakWidgetState extends State<SettingBreakWidget> {
  int counterBreakTime = 0;
  int counterInterval = 0;

  void _increment1() {
    setState(() {
      if (widget.statusSwitch) counterBreakTime++;
      widget.onBreakTimeChanged?.call(counterBreakTime);
    });
  }

  void _decrement1() {
    setState(() {
      if (widget.statusSwitch && counterBreakTime > 0) counterBreakTime--;
      widget.onBreakTimeChanged?.call(counterBreakTime);
    });
  }

  void _increment2() {
    setState(() {
      if (widget.statusSwitch) counterInterval++;
      widget.onIntervalChanged?.call(counterInterval);
    });
  }

  void _decrement2() {
    setState(() {
      if (widget.statusSwitch && counterInterval > 0) counterInterval--;
      widget.onIntervalChanged?.call(counterInterval);
    });
  }

   void resetCounter() {
    setState(() {
      counterBreakTime = 0;
      counterInterval = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 4),
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
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement1 : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : const Color(0xFF838589),
                  ),
                ),
                Expanded(
                  child: Text(
                    '$counterBreakTime',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF838589),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment1 : null,
                    icon: const Icon(Icons.add),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : const Color(0xFF838589),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(2),
            margin: const EdgeInsets.only(right: 4),
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
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _decrement2 : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : const Color(0xFF838589),
                  ),
                ),
                Expanded(
                  child: Text(
                    '$counterInterval',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF838589),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  child: IconButton(
                    onPressed: widget.statusSwitch ? _increment2 : null,
                    icon: const Icon(Icons.add),
                    iconSize: 16,
                    color: widget.statusSwitch
                        ? ripeMango
                        : const Color(0xFF838589),
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
