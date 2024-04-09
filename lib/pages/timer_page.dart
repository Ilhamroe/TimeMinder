import 'dart:ui';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/widgets/bottom_navigation.dart';
import 'package:mobile_time_minder/widgets/display_modal.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/home_rekomendasi_tile.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

final logger = Logger();
typedef ModalCloseCallback = void Function(int? id);

class DetailListTimer extends StatefulWidget {
  const DetailListTimer({Key? key});

  @override
  State<DetailListTimer> createState() => _DetailListTimerState();
}

class _DetailListTimerState extends State<DetailListTimer>
    with TickerProviderStateMixin {
  int _page = 2;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  late List<Map<String, dynamic>> _allData = [];
  List<Color> labelColors = [cetaceanBlue, cetaceanBlue, offOrange];

  late TabController tabController;
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
  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await SQLHelper.getAllData();
      setState(() {
        _allData = data;
        isLoading = false;
      });
    } catch (e) {
      logger.e("Terjadi error saat refresh data: $e");
      setState(() {
        isLoading = false;
      });
    }
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
      // Jika data baru, reset nilai controller
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
    if (_page != 2) {
      setState(() {
        _page = 2;
        updateLabelColors(_page);
      });
    }
  }

  bool swipeIsInProgress = false;
  bool tapIsBeingExecuted = false;
  int selectedIndex = 0;
  int prevIndex = 1;

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(initialIndex: selectedIndex, length: 2, vsync: this);
    tabController.animation?.addListener(() {
      if (!tapIsBeingExecuted &&
          !swipeIsInProgress &&
          (tabController.offset >= 0.5 || tabController.offset <= -0.5)) {
        int newIndex = tabController.offset > 0
            ? tabController.index + 1
            : tabController.index - 1;
        swipeIsInProgress = true;
        prevIndex = selectedIndex;
        setState(() {
          selectedIndex = newIndex;
        });
      } else {
        if (!tapIsBeingExecuted &&
            swipeIsInProgress &&
            ((tabController.offset < 0.5 && tabController.offset > 0) ||
                (tabController.offset > -0.5 && tabController.offset < 0))) {
          swipeIsInProgress = false;
          setState(() {
            selectedIndex = prevIndex;
          });
        }
      }
    });
    tabController.addListener(() {
      swipeIsInProgress = false;
      setState(() {
        selectedIndex = tabController.index;
      });
      if (tapIsBeingExecuted == true) {
        tapIsBeingExecuted = false;
      } else {
        if (tabController.indexIsChanging) {
          tapIsBeingExecuted = true;
        }
      }
    });
    updateLabelColors(_page);
  }

  @override
  void dispose() {
    tabController.dispose();
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          updateLabelColors(_page);
        });
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Timer",
            style: TextStyle(color: cetaceanBlue, fontFamily: 'Nunito-Bold'),
          ),
          leading: IconButton(
            iconSize: Checkbox.width,
            key: const Key('back'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            padding: const EdgeInsets.only(left: 15),
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 24,
              height: 24,
            ),
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 15),
              key: const Key('setting'),
              icon: SvgPicture.asset(
                "assets/images/settings.svg",
                width: 24,
                height: 24,
              ),
              onPressed: () {
                setState(() {
                  isSettingPressed = !isSettingPressed;
                });
              },
            ),
          ],
          backgroundColor: pureWhite,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: TabBar(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              onTap: (index) {
                setState(() {
                  selectedIndex;
                });
              },
              tabs: [
                Tab(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0 ? ripeMango : halfGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Semua',
                          style: TextStyle(
                              color: selectedIndex == 0
                                  ? Colors.white
                                  : cetaceanBlue),
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                    ),
                    child: Container(
                      alignment: Alignment.topCenter,
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.35,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0 ? halfGrey : ripeMango,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Timer Anda',
                          style: TextStyle(
                              color: selectedIndex == 0
                                  ? cetaceanBlue
                                  : Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 1,
                  color: halfGrey,
                ),
              ),
              labelColor: Colors.white,
              splashFactory: NoSplash.splashFactory,
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: TabBarView(
            controller: tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: 2,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return HomeRekomendasiTile(
                        isSettingPressed: isSettingPressed);
                  } else {
                    return HomeTimermuTile(isSettingPressed: isSettingPressed);
                  }
                },
              ),
              HomeTimermuTile(isSettingPressed: isSettingPressed),
            ],
          ),
        ),
        bottomNavigationBar: TimeMinderBottomNav(
          currentPageIndex: _page,
          onTap: (index) {
            setState(() {
              print("Index: $index");
              _page = index;
              updateLabelColors(_page);
              switch (_page) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                  break;
                case 1:
                  _showModal((newData) {});
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
            });
          },
        ),
      ),
    );
  }
}
