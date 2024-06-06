import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/widgets/common/help_content.dart';
import 'package:time_minder/widgets/common/slide_image.dart';
import 'package:time_minder/widgets/common/spacing.dart';
import 'package:time_minder/utils/colors.dart';

class HelpTwo extends StatefulWidget {
  const HelpTwo({super.key});

  @override
  State<HelpTwo> createState() => _HelpTwoState();
}

class _HelpTwoState extends State<HelpTwo> with TickerProviderStateMixin {
  late AnimationController _controller2;
  late Animation<Offset> offsetAnimation2;

  @override
  void initState() {
    super.initState();
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
    _controller2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Size screenSize = MediaQuery.of(context).size;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: pureWhite,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              padding: const EdgeInsets.only(left: 20).w,
              icon: SvgPicture.asset(
                "assets/images/button_back.svg",
                width: 28.w,
                height: 28.h,
              )),
          title: Text(
            "Mengedit Timer",
            style: TextStyle(
              fontFamily: 'Nunito_bold',
              fontSize: 19.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: pureWhite,
          surfaceTintColor: pureWhite,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0175.h,
                ),
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      "Bagaimana jika saya ingin mengedit timer yang telah saya tambahkan?",
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
                        "Jika kamu ingin mengedit timer yang telah kamu tambahkan sebelumnya, pergi ke menu “Timer” pada navigation bar yang terletak di bagian bawah aplikasi."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help2-1.jpg",
                      width: 300.w,
                      height: 100.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Pada menu ini akan terlihat beberapa timer yang telah kamu tambahkan sebelumnya."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                        image: "assets/images/helps/help2-2.jpg",
                        offsetAnimation: offsetAnimation2,
                        width: 300.w,
                        height: 300.h),
                  ],
                ),
                const BigSpace(),
                Row(
                  children: [
                    const Flexible(
                        child: HelpContent(
                            desc:
                                "Untuk mengedit, tap lama atau hold salah satu timer yang ingin kamu edit")),
                    Image.asset(
                      "assets/images/helps/help2-3.jpg",
                      height: 200.h,
                      width: 200.w,
                    )
                  ],
                ),
                const BigSpace(),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/helps/help2-4.jpg",
                      height: 200.h,
                      width: 200.w,
                    ),
                    const Flexible(
                        child: HelpContentRight(
                      desc:
                          "Kemudian akan muncul icon edit di bagian atas aplikasi",
                    )),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Tekan tombol tersebut untuk mengedit judul, deskripsi, waktu fokus dan waktu istirahat timer Anda."),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help2-5.jpg",
                      width: 300.w,
                      height: 300.h,
                    )
                  ],
                ),
                const BigSpace(),
                const BigSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
