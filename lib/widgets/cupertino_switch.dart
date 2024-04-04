import 'package:flutter/cupertino.dart';

class CupertinoSwitchAdaptiveWidget extends StatefulWidget {
  final bool statusSwitch;
  final Function(bool) onChanged;

  const CupertinoSwitchAdaptiveWidget({
    super.key,
    required this.statusSwitch,
    required this.onChanged,
  });

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
        data: const CupertinoThemeData(
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
            activeColor: const Color(0xFFFFBF1C),
            trackColor: const Color(0xFFC4C5C4),
          ),
        ),
      ),
    );
  }
}
