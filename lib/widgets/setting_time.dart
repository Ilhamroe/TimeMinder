import 'package:flutter/material.dart';

class SettingTimeWidget extends StatefulWidget {
  final int initialCounter;
  final ValueChanged<int>? onChanged;

  const SettingTimeWidget({
    Key? key,
    required this.initialCounter,
    this.onChanged,
  }) : super(key: key);

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
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFAF8EE),
              border: Border.all(
                color: Color(0xFFFFBF1C),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _decrement,
                      icon: Icon(Icons.remove),
                      iconSize: 18,
                      color: Color(0xFFFFBF1C),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    '$_counterMainTime',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _increment,
                      icon: Icon(Icons.add),
                      iconSize: 18,
                      color: Color(0xFFFFBF1C),
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
