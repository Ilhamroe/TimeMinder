import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/models/list_timer.dart';
import 'package:time_minder/pages/view_timer_recommedation_page.dart';
import 'package:time_minder/utils/colors.dart';

class GridRekomendasi extends StatelessWidget {
  const GridRekomendasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenSize.width < 200.w ? 2 : 3,
        crossAxisSpacing: screenSize.width * 0.03.w,
        mainAxisExtent: 185.w,
      ),
      itemCount: timerList.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10).w,
            color: offOrange,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // margin: EdgeInsets.only(top: screenSize.width * 0.03.w),
                padding: EdgeInsets.symmetric(
                  vertical: 10.5,
                  horizontal: 14,
                ).w,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(12).w,
                  color: heliotrope,
                ),
                child: SvgPicture.asset(
                  timerList[index].image,
                  height: 40.h,
                ),
              ),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 7.32, bottom: 2).w,
                    child: Text(
                      timerList[index].title,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: cetaceanBlue,
                      ),
                    ),
                  ),
                  // SizedBox(height: screenSize.width * 0.01.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2).w,
                    child: Text(
                      timerList[index].description,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: cetaceanBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // SizedBox(height: screenSize.width * 0.01.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2).w,
                    child: Text(
                      timerList[index].time,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: darkGrey,
                      ),
                    ),
                  ),
                  // SizedBox(height: screenSize.width * 0.01.h),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2).w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TimerView(timerIndex: index),
                          ),
                        );
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 5).w,
                        // padding: EdgeInsets.symmetric(horizontal: 0.01).w,
                        decoration: BoxDecoration(
                          color: ripeMango,
                          borderRadius:
                              BorderRadius.circular(5).w,
                        ),
                        child: Center(
                          child: Text(
                            "Mulai",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 12.sp,
                              color: pureWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
