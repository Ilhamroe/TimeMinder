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
  State<CupertinoSwitchAdaptiveWidget> createState() => _CupertinoSwitchAdaptiveWidgetState();
}

class _CupertinoSwitchAdaptiveWidgetState extends State<CupertinoSwitchAdaptiveWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36.0, // Lebar switch
      height: 20.0, // Tinggi switch
      child: CupertinoTheme(
        data: CupertinoThemeData(
          primaryColor: Color(0xFFFFBF1C), // Warna toggle ketika aktif
          scaffoldBackgroundColor: Color(0xFFC4C5C4), // Warna background switch
        ),
        child: Transform.scale(
          scale: 0.7, // Skala untuk menyesuaikan ukuran toggle
          child: CupertinoSwitch(
            value: widget.statusSwitch,
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
              });
            },
            activeColor: Color(0xFFFFBF1C),
            trackColor: Color(0xFFC4C5C4),
          ),
        ),
      ),
    );
  }
}
