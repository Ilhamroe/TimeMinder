import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/pages/detail_page.dart';
import 'package:time_minder/pages/faq_page.dart';
import 'package:time_minder/pages/home_page.dart';
import 'package:time_minder/pages/timer_page.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/modal_timer/add_modal.dart';
import 'package:time_minder/widgets/common/double_tap_close.dart';
import 'package:time_minder/widgets/common/custom_painter.dart';

typedef ModalCloseCallback = void Function(int? id);

class NavbarBottom extends StatefulWidget {
  const NavbarBottom({super.key});

  @override
  State<NavbarBottom> createState() => _NavbarBottomState();
}

class _NavbarBottomState extends State<NavbarBottom> {
  int? counter;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  late List<Map<String, dynamic>> _allData = [];
  final TextEditingController namaTimerController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  Future<void> _refreshData() async {
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
      builder: (_) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(top: 125).h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70).w,
                  ),
                  child: ModalAdd(id: id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    onClose(newData);
    _refreshData();
  }

  int currentTab = 0;
  final List<Widget> screens = [
    const HomePage(),
    const TimerPage(),
    const DetailPage(),
    const FaqPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  @override
  Widget build(BuildContext context) {
    return DoubleBackToCloseApp(
      snackBarMessage: 'Tekan sekali lagi untuk keluar',
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: Transform.rotate(
          angle: 45 * 3.1415926535 / 180,
          child: GestureDetector(
            onTap: () {
              _showModal((int? id) {});
            },
            child: Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFCE38), Color(0xFFE2A203)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Center(
                child: CustomPaint(
                  size: const Size(24, 24),
                  painter: PlusPainter(),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: 60.h,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2.r,
                blurRadius: 4.r,
              ),
            ],
          ),
          child: BottomAppBar(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12).w,
            elevation: 8.0.r,
            color: pureWhite,
            surfaceTintColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50).w,
                    onTap: () {
                      setState(() {
                        currentScreen = const HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentTab == 0
                            ? SvgPicture.asset(
                                'assets/images/home_bold.svg',
                                color:
                                    currentTab == 0 ? ripeMango : cetaceanBlue,
                              )
                            : SvgPicture.asset(
                                'assets/images/home.svg',
                                color:
                                    currentTab == 0 ? ripeMango : cetaceanBlue,
                              ),
                        Text(
                          'Beranda',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: currentTab == 0 ? ripeMango : cetaceanBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50).w,
                    onTap: () {
                      setState(() {
                        currentScreen = const TimerPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentTab == 1
                            ? SvgPicture.asset(
                                'assets/images/timer_bold.svg',
                                color:
                                    currentTab == 1 ? ripeMango : cetaceanBlue,
                              )
                            : SvgPicture.asset(
                                'assets/images/timer.svg',
                                color:
                                    currentTab == 1 ? ripeMango : cetaceanBlue,
                              ),
                        Text(
                          'Timer',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: currentTab == 1 ? ripeMango : cetaceanBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 56.0), // Placeholder for FAB
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50).w,
                    onTap: () {
                      setState(() {
                        currentScreen = const DetailPage();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentTab == 2
                            ? SvgPicture.asset(
                                'assets/images/detail_bold.svg',
                                color:
                                    currentTab == 2 ? ripeMango : cetaceanBlue,
                              )
                            : SvgPicture.asset(
                                'assets/images/detail.svg',
                                color:
                                    currentTab == 2 ? ripeMango : cetaceanBlue,
                              ),
                        Text(
                          'Detail',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: currentTab == 2 ? ripeMango : cetaceanBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50).w,
                    onTap: () {
                      setState(() {
                        currentScreen = const FaqPage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentTab == 3
                            ? SvgPicture.asset(
                                'assets/images/bantuan_bold.svg',
                                color:
                                    currentTab == 3 ? ripeMango : cetaceanBlue,
                              )
                            : SvgPicture.asset(
                                'assets/images/bantuan.svg',
                                color:
                                    currentTab == 3 ? ripeMango : cetaceanBlue,
                              ),
                        Text(
                          'Bantuan',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: currentTab == 3 ? ripeMango : cetaceanBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
