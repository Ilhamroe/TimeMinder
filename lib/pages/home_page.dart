import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/home_rekomendasi_tile.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ripeMango,
      // Ini sementara buat percobaan bottom navigation (diisi sama Rifqi)
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.plus_one), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Diisi sama Rifqi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hi, Mindy
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo Mindy',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Yuk, capai target fokusmu hari ini',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      // Gambar Mindy
                      SvgPicture.asset(
                        'assets/images/cat3.svg',
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(left: 15.0, top: 50.0, right: 15.0),
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            "assets/images/star.svg",
                          ),
                          SizedBox(
                            width: 8,
                          ), // Menambahkan jarak antara gambar dan teks
                          Text(
                            "Rekomendasi",
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: heliotrope,
                            ),
                          ),
                        ],
                      ),
                    ),
                    HomeRekomendasiTile(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      margin: EdgeInsets.only(left: 8.0, right: 10.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.hourglass_empty,
                            color: ripeMango,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Timer Mu",
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: ripeMango,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Lihat Semua",
                            style: TextStyle(
                              fontSize: 12,
                              color: ripeMango,
                            ),
                          ),
                        ],
                      ),
                    ),
                    HomeTimerMuTile(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
