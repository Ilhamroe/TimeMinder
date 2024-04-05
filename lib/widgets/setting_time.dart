import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

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
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _counterMainTime = widget.initialCounter;
    _textController = TextEditingController(text: _counterMainTime.toString());
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final newText = _textController.text;
    if (newText.isNotEmpty) {
      final newValue = int.tryParse(newText);
      if (newValue != null) {
        setState(() {
          _counterMainTime = newValue;
          widget.onChanged?.call(_counterMainTime);
        });
      }
    }
  }

  void _increment() {
    setState(() {
      _counterMainTime++;
      _textController.text = _counterMainTime.toString();
      widget.onChanged?.call(_counterMainTime);
    });
  }

  void _decrement() {
    setState(() {
      if (_counterMainTime > 0) {
        _counterMainTime--;
        _textController.text = _counterMainTime.toString();
        widget.onChanged?.call(_counterMainTime);
      }
    });
  }

  void resetCounter() {
    setState(() {
      _counterMainTime = 0;
      _textController.text = _counterMainTime.toString();
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
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: offYellow,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _decrement,
                      icon: Icon(Icons.remove),
                      iconSize: 18,
                      color: ripeMango,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: offYellow,
                          width: 1,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _increment,
                      icon: Icon(Icons.add),
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