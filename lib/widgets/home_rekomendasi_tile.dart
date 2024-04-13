import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/pages/view_timer_rekomendasi.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomeRekomendasiTile extends StatefulWidget {
  final bool isSettingPressed;

  const HomeRekomendasiTile({Key? key, required this.isSettingPressed})
      : super(key: key);

  @override
  State<HomeRekomendasiTile> createState() => _HomeRekomendasiTileState();
}

class _HomeRekomendasiTileState extends State<HomeRekomendasiTile> {
  final List<Color> _customColors = [
    heliotrope,
    red,
  ];

  late List<Map<String, dynamic>> allData = [];

  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;

  // refresh data
  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: Timerlist.length,
      itemBuilder: (context, index) {
        final color = _customColors[index % _customColors.length];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimerView(timerIndex: index),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: offOrange,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: color,
                  child: SvgPicture.asset(
                    Timerlist[index].image,
                    height: 30,
                  ),
                ),
              ),
              title: Text(
                Timerlist[index].title,
                style: const TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              subtitle: Text(
                Timerlist[index].description,
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              trailing: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    Timerlist[index].time,
                    style: const TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 8,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/button.svg',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String _padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${_padLeft(hours)}:${_padLeft(minutes)}:${_padLeft(seconds)}';
  }
}
