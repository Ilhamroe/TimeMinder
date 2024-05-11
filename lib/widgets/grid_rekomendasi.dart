import 'package:flutter/cupertino.dart';
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
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width < 200 ? 2 : 3,
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
        mainAxisExtent: MediaQuery.of(context).size.width * 0.49,
      ),
      itemCount: Timerlist.length,
      itemBuilder: (context, int index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.03,
            ),
            color: offOrange,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width * 0.03,
                  horizontal: MediaQuery.of(context).size.width * 0.04,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.04,
                  ),
                  color: heliotrope,
                ),
                child: SvgPicture.asset(
                  Timerlist[index].image,
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.02,
                    bottom: MediaQuery.of(context).size.width * 0.01),
                child: Text(
                  Timerlist[index].title,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MediaQuery.of(context).size.width * 0.037,
                    fontWeight: FontWeight.bold,
                    color: cetaceanBlue,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Text(
                  Timerlist[index].description,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MediaQuery.of(context).size.width * 0.025,
                    fontWeight: FontWeight.w800,
                    color: cetaceanBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 0.01,
                  right: MediaQuery.of(context).size.width * 0.01,
                ),
                child: Text(
                  Timerlist[index].time,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: MediaQuery.of(context).size.width * 0.025,
                    fontWeight: FontWeight.w800,
                    color: darkGrey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.015),
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
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.002,
                      horizontal: MediaQuery.of(context).size.width * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: ripeMango,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Mulai",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: MediaQuery.of(context).size.width * 0.032,
                          color: pureWhite,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
