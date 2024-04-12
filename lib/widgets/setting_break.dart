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
  TextEditingController _breakTimeController = TextEditingController();
  TextEditingController _intervalController = TextEditingController();

  @override
  void dispose() {
    _breakTimeController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _breakTimeController.text = "0";
    _intervalController.text = "0";
  }

  void _onBreakTimeChanged(String value) {
    if (widget.statusSwitch) {
      int breakTime = int.tryParse(value) ?? 0;
      setState(() {
        _counterBreakTime = breakTime;
      });
      widget.onBreakTimeChanged?.call(breakTime);
    }
  }

  void _onIntervalChanged(String value) {
    if (widget.statusSwitch) {
      int interval = int.tryParse(value) ?? 0;
      setState(() {
        _counterInterval = interval;
      });
      widget.onIntervalChanged?.call(interval);
    }
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
                                int.tryParse(_breakTimeController.text) ?? 0;
                            _onBreakTimeChanged((currentValue - 1).toString());
                            _breakTimeController.text =
                                (currentValue - 1).toString();
                          }
                        : null,
                    icon: Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _breakTimeController,
                    keyboardType: TextInputType.number,
                    onChanged: _onBreakTimeChanged,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
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
                                int.tryParse(_breakTimeController.text) ?? 0;
                            _onBreakTimeChanged((currentValue + 1).toString());
                            _breakTimeController.text =
                                (currentValue + 1).toString();
                          }
                        : null,
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
                  child: IconButton(
                    onPressed: widget.statusSwitch
                        ? () {
                            int currentValue =
                                int.tryParse(_intervalController.text) ?? 0;
                            _onIntervalChanged((currentValue - 1).toString());
                            _intervalController.text =
                                (currentValue - 1).toString();
                          }
                        : null,
                    icon: Icon(Icons.remove),
                    iconSize: 16,
                    color: widget.statusSwitch ? ripeMango : darkGrey,
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _intervalController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: _onIntervalChanged,
                    style: TextStyle(
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
                                int.tryParse(_intervalController.text) ?? 0;
                            _onIntervalChanged((currentValue + 1).toString());
                            _intervalController.text =
                                (currentValue + 1).toString();
                          }
                        : null,
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
