import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/pages/view_timer_rekomendasi.dart';
import 'package:mobile_time_minder/theme.dart';

class GridRekomendasi extends StatelessWidget {
  const GridRekomendasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 22.5),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Timerlist.length,
            crossAxisSpacing: 14.0,
            mainAxisExtent: screenSize.width * 0.46,
          ),
          itemCount: Timerlist.length,
          itemBuilder: (context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.71),
                color: offOrange,
              ),
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17.5),
                      color: heliotrope),
                  child: SvgPicture.asset(
                    Timerlist[index].image,
                    height: 40,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Timerlist[index].title,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: screenSize.width * 0.029,
                            fontWeight: FontWeight.bold,
                            color: cetaceanBlue),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        Timerlist[index].description,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: screenSize.width * 0.02,
                            fontWeight: FontWeight.w800,
                            color: cetaceanBlue),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        Timerlist[index].time,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: screenSize.width * 0.02,
                            fontWeight: FontWeight.w800,
                            color: darkGrey),
                          textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
                      GestureDetector(
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                          decoration: BoxDecoration(
                            color: ripeMango,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
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
                      ),
                    ],
                  ),
                ),
              ]),
            );
          }),
    );
  }
}
