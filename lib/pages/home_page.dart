import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/widgets/card_home.dart';
import 'package:mobile_time_minder/widgets/grid_rekomendasi.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.023),
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
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.015),
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
              SizedBox(height: MediaQuery.of(context).size.width * 0.028),
              const CardHome(),
              const GridRekomendasi(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/images/timer.svg'),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    const Text(
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
              SizedBox(height: MediaQuery.of(context).size.width * 0.01),
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
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child:
                          HomeTimermuTile(isSettingPressed: isSettingPressed),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
