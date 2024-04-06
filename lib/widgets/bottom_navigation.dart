import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/pages/list_timer.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  List<Color> labelColors = [offOrange, cetaceanBlue, cetaceanBlue];

  void updateLabelColors(int selectedIndex) {
    for (int i = 0; i < labelColors.length; i++) {
      labelColors[i] = cetaceanBlue;
    }
    labelColors[selectedIndex] = offOrange;
  }

  // refresh data
  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      _counter = existingData['time'] ?? 0;
      _counterBreakTime = existingData['rest'] ?? 0;
      _counterInterval = existingData['interval'] ?? 0;
    } else {
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      _counter = 0;
      _counterBreakTime = 0;
      _counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 170),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: DisplayModal(id: id),
      ),
    );
    onClose(newData);
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,
      height: 76.0,
      items: [
        CurvedNavigationBarItem(
          child: SvgPicture.asset(
            "assets/images/solar.svg",
            width: 35,
            height: 35,
          ),
          label: "BERANDA",
          labelStyle: TextStyle(
            color: labelColors[0],
            fontFamily: 'Nunito',
          ),
        ),
        CurvedNavigationBarItem(
          child: const Icon(Icons.add, size: 35),
          label: "TAMBAH",
          labelStyle: TextStyle(
            color: labelColors[1],
            fontFamily: 'Nunito',
          ),
        ),
        CurvedNavigationBarItem(
          child: const Icon(Icons.hourglass_empty_rounded, size: 35),
          label: "TIMER",
          labelStyle: TextStyle(
            color: labelColors[2],
            fontFamily: 'Nunito',
          ),
        ),
      ],
      backgroundColor: Colors.white,
      color: offOrange,
      animationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 500),
      buttonBackgroundColor: const Color(0xFFFFBF1C),
      onTap: (index) {
        setState(() {
          _page = index;
          updateLabelColors(index);
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
              break;
            case 1:
              _showModal((int? id) {});
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailListTimer(),
                ),
              );
              break;
          }
        });
      },
      letIndexChange: (index) => true,
    );
  }
}
