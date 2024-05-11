import 'package:flutter/material.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/services/tooltip_storage.dart';
import 'package:mobile_time_minder/database/db_logger.dart';
import 'package:mobile_time_minder/widgets/timer_timermu.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/widgets/bottom_navigation.dart';
import 'package:mobile_time_minder/widgets/card_home.dart';
import 'package:mobile_time_minder/widgets/grid_rekomendasi.dart';
import 'package:mobile_time_minder/widgets/tooltip_homepage.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
        print("Completed!");
        SaveInAppTour().saveHomePageStatus();
      },
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(seconds: 2), () {
      SaveInAppTour().getHomePageStatus().then((value) => {
            if (value == false)
              {
                print("User has not seen this tutor"),
                tutorialCoachMark.show(context: context)
              }
            else
              {print("User has seen this tutor")}
          });
    });
  }

  late List<Map<String, dynamic>> _allData = [];
  int? counter;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool isSettingPressed = false;
  late String _greeting;
  late String _imagePath;

  final TextEditingController namaTimerController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  // refresh data
  Future<void> _refreshData() async {
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  late List<Map<String, dynamic>> _allLogData = [];

  Future<void> _refreshLogData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> logData = await SQLLogger.getAllData();
    setState(() {
      _allLogData = logData;
      isLoading = false;
    });
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
    _refreshLogData();
    _initializeGreeting();
    counter = 0;
  }

  @override
  void dispose() {
    namaTimerController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: NavbarBottom(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
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
                          style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: screenSize.width * 0.063,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF091B35)),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SvgPicture.asset(_imagePath)
                      ],
                    ),
                    Text(
                      "Yuk capai target fokusmu hari ini",
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontSize: screenSize.width * 0.04,
                        color: ripeMango,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(key: cardHomeKey, child: const CardHome()),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.03, horizontal: 20),
                key: gridRekomendasiKey,
                child: const GridRekomendasi(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  key: timerMuKey,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset('assets/images/timer.svg'),
                        const SizedBox(width: 8),
                        Text(
                          "Timer Mu",
                          style: TextStyle(
                            fontFamily: 'Nunito-Bold',
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.w900,
                            color: cetaceanBlue,
                          ),
                        ),
                        const Spacer(),
                        // GestureDetector(
                        //   onTap: () {
                        //    Navigator.popAndPushNamed(context, AppRoutes.listTimer);
                        //   },
                        //   child: Text(
                        //     "Lihat Semua",
                        //     style: TextStyle(
                        //       fontFamily: 'Nunito',
                        //       fontSize: screenSize.width * 0.034,
                        //       color: cetaceanBlue,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: screenSize.height * 0.015,
                    ),
                    _allData.isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/cat_setting.svg",
                                width: screenSize.width * 0.3,
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width * 0.02),
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
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ListTimerPage(
                                isSettingPressed: isSettingPressed),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
