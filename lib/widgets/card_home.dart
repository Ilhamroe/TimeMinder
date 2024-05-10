import 'package:flutter/cupertino.dart';
import 'package:mobile_time_minder/database/db_logger.dart';
import 'package:mobile_time_minder/theme.dart';

class CardHome extends StatefulWidget {
  const CardHome({Key? key}) : super(key: key);

  @override
  State<CardHome> createState() => _CardHomeState();
}

class _CardHomeState extends State<CardHome> {
  bool isLoading = false;
  late List<Map<String, dynamic>> _allLogData = [];
  num totalPassed = 0;

  Future<void> _refreshLogData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> logData = await SQLLogger.getAllData();
    // print('Value of _allLogData after refresh: $_allLogData');
    setState(() {
      _allLogData = logData;
      isLoading = false;
    });
    _totalPassed();
  }

  void _totalPassed() {
    if (_allLogData.isNotEmpty) {
      for (int i = 0; i < _allLogData.length; i++) {
        if (_allLogData[i]['passed'] != null) {
          totalPassed += _allLogData[i]['passed'];
        }
      }
    }
  }

  String _formatTimeLog(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String _padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${_padLeft(hours)} jam ${_padLeft(minutes)} menit ${_padLeft(seconds)} detik';
  }

  @override
  void initState() {
    super.initState();
    _refreshLogData();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    int index = 0;
    return Container(
      height: screenSize.height * .18,
      width: screenSize.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cetaceanBlue,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/cardd.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _allLogData.isEmpty
                      ? Column(
                          children: [
                            Text(
                              'Oops! Sepertinya kamu belum\n memulai timer hari ini',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: pureWhite),
                            ),
                            Text(
                              'Yuk, mulai sekarang!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: screenSize.width * 0.067,
                                  color: pureWhite),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            Text(
                              'Hari ini kamu sudah fokus',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  color: pureWhite),
                            ),
                            Text(
                              _allLogData[index]['passed'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
                                  fontSize: screenSize.width * 0.067,
                                  color: pureWhite),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
