import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/pages/view_timer_rekomendasi.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class RecommendationTimerPage extends StatefulWidget {
  final bool isSettingPressed;

  const RecommendationTimerPage({Key? key, required this.isSettingPressed})
      : super(key: key);

  @override
  State<RecommendationTimerPage> createState() =>
      _RecommendationTimerPageState();
}

class _RecommendationTimerPageState extends State<RecommendationTimerPage> {
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
    final Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      shrinkWrap: true,
      itemCount: Timerlist.length,
      itemBuilder: (context, index) {
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
            margin: const EdgeInsets.only(top: 14.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: offOrange,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 19.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  color: heliotrope,
                  child: SvgPicture.asset(
                    Timerlist[index].image,
                    height: 35,
                  ),
                ),
              ),
              title: Text(
                Timerlist[index].title,
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: screenSize.width * 0.039,
                  color: cetaceanBlue,
                ),
              ),
              subtitle: Text(
                Timerlist[index].description,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: screenSize.width * 0.033,
                  color: cetaceanBlue,
                ),
              ),
              trailing: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    Timerlist[index].time,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: screenSize.width * 0.025,
                      color: darkGrey,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimerView(timerIndex: index),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 7),
                      decoration: BoxDecoration(
                        color: ripeMango,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Mulai",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: screenSize.width * 0.025,
                          color: pureWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
