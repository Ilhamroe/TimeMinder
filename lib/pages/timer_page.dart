import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/timer_list_page.dart';
import 'package:mobile_time_minder/pages/timer_recommendation_page.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/widgets/display_modal_add.dart';
import 'package:mobile_time_minder/theme.dart';

final logger = Logger();
typedef ModalCloseCallback = void Function(int? id);

class DetailListTimer extends StatefulWidget {
  const DetailListTimer({super.key});

  @override
  State<DetailListTimer> createState() => _DetailListTimerState();
}

class _DetailListTimerState extends State<DetailListTimer> with TickerProviderStateMixin {
  late List<Map<String, dynamic>> _allData = [];

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
  }

  bool swipeIsInProgress = false;
  bool tapIsBeingExecuted = false;
  int selectedIndex = 0;
  int prevIndex = 1;

  @override
  void initState() {
    super.initState();
    _refreshData();
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
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: pureWhite,
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
            Navigator.popAndPushNamed(context, AppRoutes.navbar);
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
            dividerColor: Colors.transparent,
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
                            color:
                                selectedIndex == 0 ? pureWhite : cetaceanBlue),
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                height: 60,
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
                        'Timer mu',
                        style: TextStyle(
                            color:
                                selectedIndex == 0 ? cetaceanBlue : pureWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                color: Colors.transparent,
              ),
            ),
            labelColor: pureWhite,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
      body: TabBarView(
          controller: tabController,
          children: [
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return RecommendationTimerPage(
                      isSettingPressed: isSettingPressed);
                } else {
                  return _allData.isEmpty
                      ? const Center(child: Text(""))
                      : ListTimerPage(
                          isSettingPressed: isSettingPressed,
                        );
                }
              },
            ),
            _allData.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/cat_setting.svg",
                        width: screenSize.width * 0.3,
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02),
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
                : ListTimerPage(
                    isSettingPressed: isSettingPressed,
                  )
          ],
        ),
    );
  }
}
