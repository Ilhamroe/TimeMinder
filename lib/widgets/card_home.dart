import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class CardHome extends StatelessWidget {
  const CardHome({
    super.key,
    // required this.context,
  });

  // final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * .18,
      width: screenSize.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cetaceanBlue,
      ),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/cardd.png',
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          const Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Oops! Sepertinya kamu\n belum memulai timer hari ini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: pureWhite),
                  ),
                  Text('Yuk, mulai sekarang!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Nunito-Bold',
                          fontSize: 22,
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
