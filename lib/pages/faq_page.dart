import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/faq_page/helpWidget1.dart';
import 'package:time_minder/widgets/faq_page/helpWidget2.dart';
import 'package:time_minder/widgets/faq_page/helpWidget3.dart';
import 'package:time_minder/widgets/faq_page/helpWidget4.dart';
import 'package:time_minder/widgets/faq_page/helpWidget5.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final List<Map<String, dynamic>> _items = [
    {
      "id": 0,
      "title": "Bagaimana cara menambahkan timer dan custom waktu istirahat",
    },
    {
      "id": 1,
      "title":
          "Bagaimana jika ingin mengedit atau menghapus timer yang telah ditambahkan?",
    },
    {
      "id": 2,
      "title": "Apakah bisa timer dijalankan di latar belakang?",
    },
    {
      "id": 3,
      "title": "Bagaimana cara untuk menghentikan timer yang berjalan?",
    },
    {
      "id": 4,
      "title": "Apa itu fitur Detail Timer dan Kalender?",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: pureWhite,
      appBar: AppBar(
        leading: IconButton(
            iconSize: Checkbox.width,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NavbarBottom(),
                ),
              );
            },
            padding: const EdgeInsets.only(left: 20).w,
            icon: SvgPicture.asset(
              "assets/images/button_back.svg",
              width: 28,
              height: 28,
            )),
        title: Text(
          "Bantuan",
          style: TextStyle(fontFamily: 'Nunito-Bold'),
        ),
        centerTitle: true,
        surfaceTintColor: pureWhite,
        backgroundColor: pureWhite,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 20).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: screenSize.height * 0.01.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: screenSize.width * 0.62.w,
                  child: Text(
                    "Halo! Mindy siap memberikan informasi yang kamu perlukan.",
                    style: TextStyle(fontSize: 20, fontFamily: 'Nunito-Bold'),
                  ),
                ),
                SizedBox(
                  child: SvgPicture.asset(
                    "assets/images/cat_hello.svg",
                    height: screenSize.height * 0.07.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.0275.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (_, index) {
                    final item = _items[index];
                    return InkWell(
                      onTap: () {
                        switch (index) {
                          case 0:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpOne()));
                            break;
                          case 1:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpTwo()));
                            break;
                          case 2:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpThree()));
                            break;
                          case 3:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpFour()));
                            break;
                          case 4:
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpFive()));
                            break;

                          default:
                            break;
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: screenSize.height * 0.02).h,
                        child: ListTile(
                          title: Text(
                            item['title'],
                          ),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8).w,
                              borderSide: BorderSide(color: gallery)),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}