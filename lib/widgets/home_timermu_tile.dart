import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/models/list_timer.dart';
import 'package:mobile_time_minder/pages/detail_timer_page.dart';
import 'package:mobile_time_minder/theme.dart';

class HomeTimerMuTile extends StatelessWidget {
  const HomeTimerMuTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      shrinkWrap: true,
      itemCount: Timerlist.length,
      itemBuilder: (BuildContext context, int index) {
        final Timer timer = Timerlist[index];
        final randomColor = Color.fromARGB(
          255,
          Random().nextInt(256), // random red value (0-255)
          Random().nextInt(256), // random green value (0-255)
          Random().nextInt(256), // random blue value (0-255)
        );
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailTimer(timer: timer),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 13.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: offOrange,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  color: randomColor,
                  child: SvgPicture.asset(
                    timer.image,
                    height: 30,
                  ),
                ),
              ),
              title: Text(
                timer.title,
                style: TextStyle(
                  fontFamily: 'Nunito-Bold',
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              subtitle: Text(
                timer.description,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    timer.time,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 8,
                      color: darkGrey,
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  SvgPicture.asset(
                    'assets/images/button.svg',
                    height: 20,
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
