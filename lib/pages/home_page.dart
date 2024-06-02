import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_minder/database/db_calendar.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/timer_list_page_no_hold.dart';
import 'package:time_minder/widgets/home_page/banner_home.dart';
import 'package:time_minder/widgets/home_page/grid_recommendation.dart';
import 'package:time_minder/widgets/home_page/tooltip_homepage.dart';
import 'package:time_minder/services/tooltip_storage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final cardHomeKey = GlobalKey();
  final gridRekomendasiKey = GlobalKey();
  final timerMuKey = GlobalKey();
  final addButtonKey = GlobalKey();

  late TutorialCoachMark tutorialCoachMark;

  bool isSaved = true;

  void _inithomePageInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: homePageTargets(
        cardHomeKey: cardHomeKey,
        gridRekomendasiKey: gridRekomendasiKey,
        timerMuKey: timerMuKey,
      ),
      pulseEnable: false,
      colorShadow: darkGrey,
      paddingFocus: 20,
      hideSkip: true,
      opacityShadow: 0.5,
      onFinish: () {
        // print("Completed!");
        SaveInAppTour().saveHomePageStatus();
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(milliseconds: 30), () {
      SaveInAppTour().getHomePageStatus().then((value) => {
            if (value == false)
              {
                // print("User has not seen this tutor"),
                tutorialCoachMark.show(context: context)
              }
            // else
            //   {print("User has seen this tutor")}
          });
    });
  }

  int totalElapsed = 0;
  late List<Map<String, dynamic>> allData = [];
  late List<Map<String, dynamic>> _allData = [];
  bool isLoading = false;
  bool isSettingPressed = false;
  late String _greeting;
  late String _imagePath;

  // refresh data
  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  Future<void> refreshData() async {
    final List<Map<String, dynamic>> data = await DBCalendar.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  void _totalElapsed() async {
    final data = await DBCalendar.getSingleDate(DateTime.now());
    data.forEach((element) {
      totalElapsed += element['elapsed'] as int;
    });
    // print(totalElapsed);
  }

  String formatElapsedTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours jam ';
    }
    if (minutes > 0) {
      formattedTime += '$minutes menit ';
    }
    formattedTime += '$seconds detik';

    return formattedTime;
  }

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
    _inithomePageInAppTour();
    _showInAppTour();
    _refreshData();
    refreshData();
    _totalElapsed();
    _initializeGreeting();
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: pureWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 25).w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$_greeting ',
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            fontSize: 22.42.sp,
                            fontWeight: FontWeight.w900,
                            color: cetaceanBlue,
                          ),
                        ),
                        SvgPicture.asset(_imagePath)
                      ],
                    ),
                    Text(
                      "Yuk capai target fokusmu hari ini",
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: 14.sp,
                        color: ripeMango,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20).w,
                child: SizedBox(key: cardHomeKey, child: const BannerHome()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenSize.height * 0.03.h,
                  horizontal: 20.w,
                ),
                child: SizedBox(key: gridRekomendasiKey, child: const GridRekomendasi()),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.03,
                  right: 20,
                  left: 20,
                ).w,
                child: Column(
                  key: timerMuKey,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/timer.svg'),
                        SizedBox(width: 10.w),
                        Text(
                          "Timer Mu",
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: cetaceanBlue,
                          ),
                        ),
                      ],
                    ),
                    _allData.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/cat_setting.svg",
                                width: 130.w,
                                height: 130.h,
                              ),
                              10.verticalSpace,
                              Text(
                                "Ayo tambahkan timer sesuai keinginanmu!",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14.sp,
                                  color: darkGrey,
                                ),
                              ),
                            ],
                          )
                        : ListTimerPageNoHold(
                            isSettingPressed: isSettingPressed)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
