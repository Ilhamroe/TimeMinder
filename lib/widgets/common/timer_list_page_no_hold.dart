import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/pages/view_list_timer_page.dart';
import 'package:time_minder/utils/colors.dart';

typedef ModalCloseCallback = void Function(int? id);

class ListTimerPageNoHold extends StatefulWidget {
  final bool isSettingPressed;

  const ListTimerPageNoHold({super.key, required this.isSettingPressed});

  @override
  State<ListTimerPageNoHold> createState() => _ListTimerPageNoHoldState();
}

class _ListTimerPageNoHoldState extends State<ListTimerPageNoHold> {
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  late List<Map<String, dynamic>> _allData = [];
  // refresh data
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

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void dispose() {
    _namaTimerController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _allData.length,
      itemBuilder: (context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CombinedTimerPage(
                  id: _allData[index]['id'],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 14.0).h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0).w,
              color: offOrange,
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 19.0).w,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(5).w,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10).w,
                  color: heliotrope,
                  child: SvgPicture.asset(
                    'assets/images/cat1.svg',
                    height: 30.h,
                  ),
                ),
              ),
              title: Text(
                _allData[index]['title'],
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Text(
                _allData[index]['description'],
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_allData[index]['timer']),
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 9.sp,
                      color: darkGrey,
                    ),
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 7).w,
                    decoration: BoxDecoration(
                      color: ripeMango,
                      borderRadius: BorderRadius.circular(5).w,
                    ),
                    child: Text(
                      "Mulai",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9.sp,
                        color: pureWhite,
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

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${padLeft(hours)}:${padLeft(minutes)}:${padLeft(seconds)}';
  }
}
