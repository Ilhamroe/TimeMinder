import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/theme.dart';

class TimeMinderBottomNav extends StatefulWidget {
  final int currentPageIndex;
  final ValueChanged<int> onTap;

  TimeMinderBottomNav({
    Key? key,
    required this.currentPageIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  _TimeMinderBottomNavState createState() => _TimeMinderBottomNavState();
}

class _TimeMinderBottomNavState extends State<TimeMinderBottomNav> {
  List<Color> labelColors = [cetaceanBlue];
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        index: widget.currentPageIndex == 1 ? 0 : widget.currentPageIndex,
        key: _bottomNavigationKey,
        height: 69.0,
        items: [
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              "assets/images/solar.svg",
              width: 25,
              height: 25,
            ),
            label: "BERANDA",
            labelStyle: TextStyle(
              color: labelColors[0],
              fontFamily: 'Nunito',
            ),
          ),
          CurvedNavigationBarItem(
            child: const Icon(
              Icons.add,
              size: 20,
            ),
            label: "TAMBAH",
            labelStyle: TextStyle(
              color: labelColors[0],
              fontFamily: 'Nunito',
            ),
          ),
          CurvedNavigationBarItem(
            child: const Icon(
              Icons.hourglass_empty_rounded,
              size: 25,
            ),
            label: "TIMER",
            labelStyle: TextStyle(
              color: labelColors[0],
              fontFamily: 'Nunito',
            ),
          ),
        ],
        backgroundColor: Colors.white,
        color: offOrange,
        animationCurve: Curves.linear,
        animationDuration: const Duration(milliseconds: 500),
        buttonBackgroundColor: ripeMango,
        onTap: (index) {widget.onTap(index);},
    );
  }

}
