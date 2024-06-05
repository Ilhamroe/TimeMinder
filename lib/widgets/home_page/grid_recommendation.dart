import 'package:flutter/material.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 40.w - 20.w) / 3;

    return Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(timerList.length, (index) {
              return Container(
                width: itemWidth,
                padding: const EdgeInsets.only(top: 10.0).w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10).w,
                  color: offOrange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.5,
                        horizontal: 14,
                      ).w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12).w,
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
                          margin: const EdgeInsets.only(
                                  top: 7.32, bottom: 2, right: 8, left: 8)
                              .w,
                          child: Text(
                            timerList[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: cetaceanBlue,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                                  .w,
                          child: Text(
                            timerList[index].description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w800,
                              color: cetaceanBlue,
                            ),
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2)
                                  .w,
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
                        Container(
                          margin: EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 10.37)
                              .w,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TimerView(timerIndex: index),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ripeMango,
                                borderRadius: BorderRadius.circular(5).w,
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
            }),
          ),
        ],
      ),
    );
  }
}
