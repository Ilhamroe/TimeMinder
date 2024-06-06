import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/help_content.dart';
import 'package:time_minder/widgets/common/slide_image.dart';
import 'package:time_minder/widgets/common/spacing.dart';

class HelpFive extends StatefulWidget {
  const HelpFive({super.key});

  @override
  State<HelpFive> createState() => _HelpFiveState();
}

class _HelpFiveState extends State<HelpFive> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;
  late AnimationController _controller2;
  late Animation<Offset> offsetAnimation2;

  @override
  void initState() {
    super.initState();
    //kiri-kanan
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();

    //kanan-kiri
    _controller2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation2 = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller2, curve: Curves.easeIn));
    _controller2.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          backgroundColor: pureWhite,
          surfaceTintColor: pureWhite,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                "assets/images/button_back.svg",
                width: 28.w,
                height: 28.h,
              )),
          title: Text(
            "Fitur Detail Timer dan Kalender",
            style: TextStyle(
              fontFamily: 'Nunito_bold',
              fontSize: 19.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05).w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenSize.height * 0.0175.h,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      "Apa itu fitur detail timer dan kalender?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                      ),
                    )),
                  ],
                ),
                const CustomSpace(),
                const HelpContent(
                    desc:
                        "Fitur “Detail Timer” dan “Kalender” merupakan fitur baru yang ada pada aplikasi TimeMinder, fitur ini memungkinkan kamu untuk melihat informasi lebih lanjut tentang Timer yang telah kamu jalankan pada hari tersebut."),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                      image: "assets/images/helps/help5-3.jpg",
                      offsetAnimation: offsetAnimation,
                      width: 300.w,
                      height: 100.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Ini adalah Detail Timer dan Kalender Anda. Jika Anda memilih tanggal dimana Anda tidak menambahkan timer pada hari tersebut, maka Detail Timer menunjukkan bahwa history timer pada hari tersebut kosong."),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                      image: "assets/images/helps/help5-1.png",
                      offsetAnimation: offsetAnimation,
                      width: 300.w,
                      height: 300.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Sebaliknya, jika Anda melihat tanggal dimana Anda menambahkan timer pada hari tersebut, maka akan terlihat riwayat timer yang telah Anda tambahkan"),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                      image: "assets/images/helps/help5-2.png",
                      offsetAnimation: offsetAnimation2,
                      width: 300.w,
                      height: 300.h,
                    ),
                  ],
                ),
                const BigSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
