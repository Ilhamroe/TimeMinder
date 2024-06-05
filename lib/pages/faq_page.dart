import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/bottom_navbar.dart';
import 'package:time_minder/widgets/faq_page/help_widget1.dart';
import 'package:time_minder/widgets/faq_page/help_widget2.dart';
import 'package:time_minder/widgets/faq_page/help_widget3.dart';
import 'package:time_minder/widgets/faq_page/help_widget4.dart';
import 'package:time_minder/widgets/faq_page/help_widget5.dart';

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
      "title": "Bagaimana jika ingin mengedit timer yang telah ditambahkan?",
    },
    {
      "id": 2,
      "title": "Bagaimana jika ingin menghapus timer yang telah ditambahkan?",
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
              iconSize: Checkbox.width,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavbarBottom()),
                );
              },
              padding: const EdgeInsets.only(left: 20).w,
              icon: SvgPicture.asset(
                "assets/images/button_back.svg",
                width: 28.w,
                height: 28.h,
              )),
          title: const Text(
            "Bantuan",
            style: TextStyle(fontFamily: 'Nunito-Bold'),
          ),
          centerTitle: true,
          surfaceTintColor: pureWhite,
          backgroundColor: pureWhite,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20).w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        "Halo! Mindy siap memberikan informasi yang kamu perlukan.",
                        style: TextStyle(
                            fontSize: 15.sp, fontFamily: 'Nunito-Bold'),
                      ),
                    ),
                    SizedBox(
                      child: SvgPicture.asset(
                        "assets/images/cat_hello.svg",
                        height: 50.h,
                        width: 50.h,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (_, index) {
                      final item = _items[index];
                      return Padding(
                        padding:
                            EdgeInsets.only(bottom: screenSize.height * 0.02).h,
                        child: InkWell(
                          onTap: () {
                            switch (index) {
                              case 0:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HelpOne()));
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HelpTwo()));
                                break;
                              case 2:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HelpThree()));
                                break;
                              case 3:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HelpFour()));
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HelpFive()));
                                break;

                              default:
                                break;
                            }
                          },
                          child: ListTile(
                            title: Text(
                              item['title'],
                            ),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8).w,
                                borderSide: const BorderSide(color: gallery)),
                            trailing: const Icon(
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
      ),
    );
  }
}
