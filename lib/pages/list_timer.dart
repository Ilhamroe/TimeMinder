import 'dart:ui';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
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
  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isSemuaSelected = true;
  bool isSettingPressed = false;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  void updateLabelColors(int selectedIndex) {
    for (int i = 0; i < labelColors.length; i++) {
      labelColors[i] = cetaceanBlue;
    }
    labelColors[selectedIndex] = cetaceanBlue;
  }

  // refresh data
  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    try{
      final data= await SQLHelper.getAllData();
      setState(() {
        _allData= data;
        isLoading= false;
      });
    }catch(e){
      logger.e("Terjadi error saat refresh data: $e");
      setState(() {
        isLoading= false;
      });
    }
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Data deleted"),
        duration: Duration(milliseconds: 500),
      ));
    }
    _refreshData();
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
      // Jika data baru, reset nilai controller
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      _counter = 0;
      _counterBreakTime = 0;
      _counterInterval = 0;
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
  }

  @override
  void dispose() {
    tabController.dispose();
    // _refreshData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Navigator.popUntil(context, ModalRoute.withName(AppRoutes.home));
          },
          padding: const EdgeInsets.only(left: 25),
          icon: SvgPicture.asset(
            "assets/images/button_back.svg",
            width: 30,
            height: 30,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 25),
            key: const Key('setting'),
            icon: SvgPicture.asset(
              "assets/images/settings.svg",
              width: 30,
              height: 30,
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
                    left: 30,
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: 40,
                    width: 150,
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
                    right: 30,
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 40,
                    width: 150,
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
            )),
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
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                HomeRekomendasiTile(isSettingPressed: isSettingPressed),
                HomeTimermuTile(isSettingPressed: isSettingPressed),
              ],
            ),
            HomeTimermuTile(isSettingPressed: isSettingPressed),
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
            label: "BERANDA",
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
              updateLabelColors(index);
              switch (index) {
                case 0:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                  break;
                case 1:
                  _showModal((int? id) {});
                  break;
                case 2:
                  _refreshData();
                  break;
              }
            },
          );
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
