import 'dart:ui';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/widgets/card_home.dart';
import 'package:mobile_time_minder/widgets/display_modal_add.dart';
import 'package:mobile_time_minder/widgets/grid_rekomendasi.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late List<Map<String, dynamic>> _allData = [];
  List<Color> labelColors = [offOrange, cetaceanBlue, cetaceanBlue];

  int? counter;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isSemuaSelected = true;
  bool isSettingPressed = false;

  final TextEditingController namaTimerController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  void updateLabelColors(int selectedIndex) {
    for (int i = 0; i < labelColors.length; i++) {
      labelColors[i] = i == selectedIndex ? offOrange : cetaceanBlue;
    }
  }

  // refresh data
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  void getSingleData(int id) async {
    final data = await SQLHelper.getSingleData(id);
    final int timerValue = data[0]['timer'] ?? 0;

    setState(() {
      namaTimerController.text = data[0]['title'];
      deskripsiController.text = data[0]['description'];
      counter = timerValue;
      counterBreakTime = data[0]['rest'] ?? 0;
      counterInterval = data[0]['interval'] ?? 0;
    });
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      namaTimerController.text = existingData['title'];
      deskripsiController.text = existingData['description'];
      counter = existingData['time'] ?? 0;
      counterBreakTime = existingData['rest'] ?? 0;
      counterInterval = existingData['interval'] ?? 0;
    } else {
      namaTimerController.text = '';
      deskripsiController.text = '';
      counter = 0;
      counterBreakTime = 0;
      counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          // Modal content
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
              ),
              child: DisplayModalAdd(id: id),
            ),
          ),
        ],
      ),
    );
    onClose(newData);
    _refreshData();
    if (_page != 0) {
      setState(() {
        _page = 0;
        updateLabelColors(_page);
        _refreshData();
      });
    }
  }

  late String _greeting;
  late String _imagePath;

  void _initializeGreeting() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;

    setState(() {
      if (currentHour >= 5 && currentHour < 12) {
        _greeting = 'Selamat Pagi';
        _imagePath = 'assets/images/pagi.svg';
      } else if (currentHour >= 12 && currentHour < 15) {
        _greeting = 'Selamat Siang';
        _imagePath = 'assets/images/siang.svg';
      } else if (currentHour >= 15 && currentHour < 19) {
        _greeting = 'Selamat Sore';
        _imagePath = 'assets/images/sore.svg';
      } else {
        _greeting = 'Selamat Malam';
        _imagePath = 'assets/images/malam.svg';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _initializeGreeting();
    updateLabelColors(_page);
    counter = 0;
  }

  @override
  void dispose() {
    namaTimerController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          updateLabelColors(2);
        });
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 22,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '$_greeting',
                            style: const TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 22.42,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF091B35)),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(_imagePath)
                        ],
                      ),
                      const Text(
                        "Yuk capai target fokusmu hari ini",
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontSize: 14,
                          color: ripeMango,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                const CardHome(),
                const GridRekomendasi(),
                // timermutile_home(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/images/timer.svg'),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Timer Mu",
                        style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: cetaceanBlue,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DetailListTimer(),
                            ),
                          );
                        },
                        child: const Text(
                          "Lihat Semua",
                          style: TextStyle(
                            fontSize: 12,
                            color: cetaceanBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _allData.isEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/cat_setting.svg",
                            width: screenSize.width * 0.3,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Ayo tambahkan timer sesuai keinginanmu!",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: darkGrey,
                            ),
                          ),
                        ],
                      )
                    : HomeTimermuTile(isSettingPressed: isSettingPressed),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _navbar(context),
      ),
    );
  }

  CurvedNavigationBar _navbar(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: _page,
      height: 65.0,
      items: [
        CurvedNavigationBarItem(
          child: SvgPicture.asset(
            "assets/images/solar.svg",
            width: 25,
            height: 25,
          ),
          label: _page == 0 ? null : "BERANDA",
          labelStyle: TextStyle(
            color: labelColors[0],
            fontFamily: 'Nunito',
          ),
        ),
        CurvedNavigationBarItem(
          child: const Icon(
            Icons.add,
            size: 25,
          ),
          label: "TAMBAH",
          labelStyle: TextStyle(
            color: labelColors[1],
            fontFamily: 'Nunito',
          ),
        ),
        CurvedNavigationBarItem(
          child: const Icon(
            Icons.hourglass_empty_rounded,
            size: 25,
          ),
          label: _page == 2 ? null : "TIMER",
          labelStyle: TextStyle(
            color: labelColors[2],
            fontFamily: 'Nunito',
          ),
        ),
      ],
      backgroundColor: pureWhite,
      color: offOrange,
      animationCurve: Curves.bounceInOut,
      animationDuration: const Duration(milliseconds: 500),
      buttonBackgroundColor: const Color(0xFFFFBF1C),
      onTap: (index) {
        setState(
          () {
            _page = index;
            updateLabelColors(_page);
            switch (_page) {
              case 0:
                _refreshData();
                break;
              case 1:
                _showModal((int? id) {});
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailListTimer(),
                  ),
                );
                break;
            }
          },
        );
      },
      letIndexChange: (index) => true,
    );
  }
}

