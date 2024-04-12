import 'dart:ui';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/widgets/display_modal.dart';
import 'package:mobile_time_minder/widgets/home_rekomendasi_tile.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';
import '../widgets/bottom_navigation.dart';

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

  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isSemuaSelected = true;
  bool isSettingPressed = false;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

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

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      counter = existingData['time'] ?? 0;
      counterBreakTime = existingData['rest'] ?? 0;
      counterInterval = existingData['interval'] ?? 0;
    } else {
      _namaTimerController.text = '';
      _deskripsiController.text = '';
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
              margin: const EdgeInsets.only(top: 170),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
              ),
              child: DisplayModal(id: id),
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

  void _initializeGreeting() {
    final currentTime = DateTime.now();
    final currentHour = currentTime.hour;

    setState(() {
      if (currentHour >= 5 && currentHour < 12) {
        _greeting = 'Selamat Pagi';
      } else if (currentHour >= 12 && currentHour < 15) {
        _greeting = 'Selamat Siang';
      } else if (currentHour >= 15 && currentHour < 19) {
        _greeting = 'Selamat Sore';
      } else {
        _greeting = 'Selamat Malam';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
    _initializeGreeting();
    updateLabelColors(_page);
  }

  @override
  void dispose() {
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          updateLabelColors(2);
        });
        return true;
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              stops: [0.5, 1],
              colors: [ripeMango, pureWhite],
            ),
          ),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                leading: Icon(Icons.arrow_back, color: ripeMango),
                title: SizedBox.shrink(),
                floating: true,
                snap: true,
                backgroundColor: ripeMango,
                elevation: 0,
                expandedHeight: screenSize.height * 0.22,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.14,
                      vertical: screenSize.height * 0.02,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_greeting',
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  color: Colors.black,
                                  fontSize: screenSize.width * 0.06,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: screenSize.height * 0.005,
                              ),
                              Text(
                                'Yuk, capai target\nfokusmu hari ini',
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 3,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  color: Colors.black,
                                  fontSize: screenSize.width * 0.045,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: screenSize.width * 0.3,
                          height: screenSize.height * 0.2,
                          padding: EdgeInsets.only(
                            top: screenSize.height * 0.01,
                            bottom: screenSize.height * 0.02,
                            left: screenSize.width * 0.07,
                          ),
                          child: SvgPicture.asset(
                            "assets/images/cat3.svg",
                            width: screenSize.width * 0.3,
                            height: screenSize.width * 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: pureWhite,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 50.0, right: 15.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/star.svg",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Rekomendasi",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: heliotrope,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          HomeRekomendasiTile(
                              isSettingPressed: isSettingPressed),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            margin:
                                const EdgeInsets.only(left: 8.0, right: 10.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.hourglass_empty,
                                  color: ripeMango,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Timer Mu",
                                  style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: ripeMango,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const DetailListTimer(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Lihat Semua",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ripeMango,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          HomeTimermuTile(
                            isSettingPressed: isSettingPressed,
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
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
        ),
      ),
    );
  }
}
