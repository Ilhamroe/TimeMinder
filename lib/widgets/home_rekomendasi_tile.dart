import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/pages/view_timer_rekomendasi.dart';
import 'package:mobile_time_minder/theme.dart';

class HomeRekomendasiTile extends StatefulWidget {
  const HomeRekomendasiTile({super.key});

  @override
  State<HomeRekomendasiTile> createState() => _HomeRekomendasiTileState();
}

class _HomeRekomendasiTileState extends State<HomeRekomendasiTile> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
                    color: cetaceanBlue),
              ),
              subtitle: Text(
                Timerlist[index].description,
                style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: screenSize.width * 0.033,
                    color: cetaceanBlue),
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
                          builder: (context) => TimerView(
                            timerIndex: index
                          ),
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
