import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class CardHome extends StatelessWidget {
  const CardHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * .18,
      width: screenSize.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cetaceanBlue,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/cardd.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Oops! Sepertinya kamu belum\n memulai timer hari ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: pureWhite),
                  ),
                  Text('Yuk, mulai sekarang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontSize: screenSize.width * 0.067,
                          color: pureWhite)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}