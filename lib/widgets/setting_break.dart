import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class SettingBreakWidget extends StatefulWidget {
  final bool statusSwitch;
  final ValueChanged<int>? onBreakTimeChanged;
  final ValueChanged<int>? onIntervalChanged;
  final int initialBreakTime;
  final int initialInterval;

  const SettingBreakWidget({
    Key? key,
    required this.statusSwitch,
    this.onBreakTimeChanged,
    this.onIntervalChanged,
    required this.initialBreakTime,
    required this.initialInterval,
  }) : super(key: key);

  @override
  SettingBreakWidgetState createState() => SettingBreakWidgetState();
}

class SettingBreakWidgetState extends State<SettingBreakWidget> {
  int counterBreakTime = 0;
  int counterInterval = 0;
  TextEditingController breakTimeController = TextEditingController();
  TextEditingController intervalController = TextEditingController();

  @override
  void dispose() {
    breakTimeController.dispose();
    intervalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    counterBreakTime = widget.initialBreakTime;
    counterInterval = widget.initialInterval;
    breakTimeController =
        TextEditingController(text: counterBreakTime.toString());
    intervalController =
        TextEditingController(text: counterInterval.toString());
  }

  void _onBreakTimeChanged(String value) {
    if (widget.statusSwitch) {
      int breakTime = int.tryParse(value) ?? 0;
      if (breakTime > 0) {
        setState(() {
          counterBreakTime = breakTime;
        });
        widget.onBreakTimeChanged?.call(breakTime);
      }
    }
  }

  void _onIntervalChanged(String value) {
    if (widget.statusSwitch) {
      int interval = int.tryParse(value) ?? 0;
      if (interval > 0) {
        setState(() {
          counterInterval = interval;
        });
        widget.onIntervalChanged?.call(interval);
      }
    }
  }

  void resetCounter() {
    setState(() {
      counterBreakTime = 0;
      counterInterval = 0;
    });
  }

  // Method untuk mengatur nilai awal input field pada SettingBreakWidget
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
                    onPressed: widget.statusSwitch
                        ? () {
                            int currentValue =
                                int.tryParse(breakTimeController.text) ?? 0;
                            if (currentValue > 0) {
                              _onBreakTimeChanged(
                                  (currentValue - 1).toString());
                              breakTimeController.text =
                                  (currentValue - 1).toString();
                            }
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: breakTimeController,
                    keyboardType: TextInputType.number,
                    onChanged: _onBreakTimeChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: widget.statusSwitch
                        ? () {
                            int currentValue =
                                int.tryParse(breakTimeController.text) ?? 0;
                            _onBreakTimeChanged((currentValue + 1).toString());
                            breakTimeController.text =
                                (currentValue + 1).toString();
                          }
                        : null,
                    icon: const Icon(Icons.add),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Container(
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
                Container(
                  child: IconButton(
                    onPressed: widget.statusSwitch
                        ? () {
                            int currentValue =
                                int.tryParse(intervalController.text) ?? 0;
                            if (currentValue > 0) {
                              _onIntervalChanged((currentValue - 1).toString());
                              intervalController.text =
                                  (currentValue - 1).toString();
                            }
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: intervalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: _onIntervalChanged,
                    style: const TextStyle(
                      fontSize: 12,
                      color: darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: IconButton(
                    onPressed: widget.statusSwitch
                        ? () {
                            int currentValue =
                                int.tryParse(intervalController.text) ?? 0;
                            _onIntervalChanged((currentValue + 1).toString());
                            intervalController.text =
                                (currentValue + 1).toString();
                          }
                        : null,
                    icon: const Icon(Icons.add),
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
