import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class SettingTimeWidget extends StatefulWidget {
  final int initialCounter;
  final ValueChanged<int>? onChanged;

  const SettingTimeWidget({
    super.key,
    required this.initialCounter,
    this.onChanged,
  });

  @override
  SettingTimeWidgetState createState() => SettingTimeWidgetState();
}

class SettingTimeWidgetState extends State<SettingTimeWidget> {
  late int _counterMainTime;

  @override
  void initState() {
    super.initState();
    _counterMainTime = widget.initialCounter;
  }

  void _increment() {
    setState(() {
      _counterMainTime++;
      widget.onChanged?.call(_counterMainTime); 
    });
  }

  void _decrement() {
    setState(() {
      if (_counterMainTime > 0) {
        _counterMainTime--;
        widget.onChanged?.call(_counterMainTime); 
      }
    });
  }

  void resetCounter() {
    setState(() {
      _counterMainTime = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: offYellow,
              border: Border.all(
                color: ripeMango,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: offYellow,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove),
                      iconSize: 18,
                      color: ripeMango,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$_counterMainTime',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: offYellow,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _increment,
                      icon: const Icon(Icons.add),
                      iconSize: 18,
                      color: ripeMango,
                    ),
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
