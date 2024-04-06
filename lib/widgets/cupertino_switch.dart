import 'package:flutter/cupertino.dart';

class CupertinoSwitchAdaptiveWidget extends StatefulWidget {
  final bool statusSwitch;
  final Function(bool) onChanged;

  const CupertinoSwitchAdaptiveWidget({
    Key? key,
    required this.statusSwitch,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CupertinoSwitchAdaptiveWidget> createState() =>
      _CupertinoSwitchAdaptiveWidgetState();
}

class _CupertinoSwitchAdaptiveWidgetState
    extends State<CupertinoSwitchAdaptiveWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final switchWidth = screenWidth * 0.09;
    final switchHeight = screenWidth * 0.05; 

    return SizedBox(
      width: switchWidth,
      height: switchHeight,
      child: CupertinoTheme(
        data: const CupertinoThemeData(
          primaryColor: Color(0xFFFFBF1C),
          scaffoldBackgroundColor: Color(0xFFC4C5C4),
        ),
        child: Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: widget.statusSwitch,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
            activeColor: const Color(0xFFFFBF1C),
            trackColor: const Color(0xFFC4C5C4),
          ),
        ),
      ),
    );
  }
}
