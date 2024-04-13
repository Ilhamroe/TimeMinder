import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/theme.dart';

class TimeMinderBottomNav extends StatelessWidget {
  final int currentPageIndex;
  final ValueChanged<int> onTap;

  const TimeMinderBottomNav({
    super.key,
    required this.currentPageIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPageIndex,
      onTap: onTap,
      backgroundColor: Colors.white,
      selectedItemColor: offOrange,
      unselectedItemColor: cetaceanBlue,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            "assets/images/solar.svg",
            width: 20,
            height: 20,
          ),
          label: "BERANDA",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: "TAMBAH",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.hourglass_empty_rounded),
          label: "TIMER",
        ),
      ],
    );
  }
}
