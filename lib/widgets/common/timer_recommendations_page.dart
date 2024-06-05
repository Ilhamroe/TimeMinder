import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/models/list_timer.dart';
import 'package:time_minder/pages/view_timer_recommedation_page.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:time_minder/widgets/common/providers.dart';

typedef ModalCloseCallback = void Function(int? id);

class RecommendationTimerPage extends StatefulWidget {
  final bool isSettingPressed;

  const RecommendationTimerPage({super.key, required this.isSettingPressed});

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
    final selectedItemsProvider = Provider.of<SelectedItemsProvider>(context);
    final selectedItems = selectedItemsProvider.selectedItems;
    // final Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timerList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: selectedItems.isNotEmpty
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text("Oops! Timer ini tidak dapat diubah."),
                    duration: Duration(milliseconds: 500),
                    behavior: SnackBarBehavior.floating,
                  ));
                }
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TimerView(timerIndex: index),
                    ),
                  );
                },
          onLongPress: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text("Oops! Timer ini tidak dapat diubah."),
              duration: Duration(milliseconds: 500),
              behavior: SnackBarBehavior.floating,
            ));
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
                    timerList[index].image,
                    height: 30.h,
                  ),
                ),
              ),
              title: Text(
                timerList[index].title,
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: 14.sp,
                ),
              ),
              subtitle: Text(
                timerList[index].description,
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
                    timerList[index].time,
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
                  GestureDetector(
                      onTap: selectedItems.isNotEmpty
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TimerView(timerIndex: index),
                                ),
                              );
                            },
                      child: selectedItems.isNotEmpty
                          ? Container()
                          : IgnorePointer(
                              ignoring: selectedItems.isNotEmpty,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 7)
                                    .w,
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
                            )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
