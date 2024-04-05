import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class ColorChanger extends StatefulWidget {
  final Function(bool) onChanged;
  final bool isSelected;

  const ColorChanger({super.key, required this.onChanged, required this.isSelected});

  @override
  ColorChangerState createState() => ColorChangerState();
}

class ColorChangerState extends State<ColorChanger> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isSelected);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: widget.isSelected ? ripeMango : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            widget.isSelected ? 'Timer Anda' : 'Semua',
            style: TextStyle(color: widget.isSelected ? Colors.white : cetaceanBlue),
          ),
        ),
      ),
    );
  }
}
