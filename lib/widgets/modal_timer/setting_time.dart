import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/utils/colors.dart';

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
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _counterMainTime = widget.initialCounter;
    _textController = TextEditingController(text: _counterMainTime.toString());
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final newText= _textController.text;
    if(newText.isEmpty){
      setState(() {
        _counterMainTime = 0;
        _textController.text= '0';
        _textController.selection= const TextSelection.collapsed(offset: 1);
      });
      widget.onChanged?.call(_counterMainTime);
    }else{
      final newValue= int.tryParse(newText);
      if(newValue != null){
        setState(() {
          _counterMainTime= newValue;
          _textController.value= TextEditingValue(
            text: _counterMainTime.toString(),
            selection: TextSelection.collapsed(offset: _counterMainTime.toString().length),
          );
        });
        widget.onChanged?.call(_counterMainTime);
      }
    }
  }

  void updateCounter(int newCounter) {
    _counterMainTime = newCounter;
    widget.onChanged?.call(newCounter);
    _textController.text = _counterMainTime.toString();
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
    final Size screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(screenSize.width * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10).w,
              color: offYellow,
              border: Border.all(
                color: ripeMango,
                width: 1.w,
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
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _decrement,
                      icon: const Icon(Icons.remove),
                      iconSize: screenSize.width * 0.05.h,
                      color: ripeMango,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: darkGrey,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (text) {
                      _onTextChanged();
                    },
                    onTap: () {
                      if(_textController.text == '0'){
                        _textController.clear();
                      }
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: offYellow,
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _increment,
                      icon: const Icon(Icons.add),
                      iconSize: screenSize.width * 0.05.h,
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
