import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/widgets/common/help_content.dart';
import 'package:time_minder/widgets/common/slide_image.dart';
import 'package:time_minder/widgets/common/spacing.dart';
import 'package:time_minder/utils/colors.dart';

class HelpThree extends StatefulWidget {
  const HelpThree({super.key});

  @override
  State<HelpThree> createState() => _HelpThreeState();
}

class _HelpThreeState extends State<HelpThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    offsetAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
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
            "Menghapus Timer",
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
                      "Bagaimana jika saya ingin menghapus timer yang telah saya tambahkan?",
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
                        "Jika kamu ingin menghapus timer yang telah kamu tambahkan sebelumnya, pergi ke menu “Timer” pada navigation bar yang terletak di bagian bawah aplikasi."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help3-1.jpg",
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
                        image: "assets/images/helps/help3-2.jpg",
                        offsetAnimation: offsetAnimation,
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
                                "Untuk menghapus, tap lama atau hold pada timer yang ingin kamu hapus")),
                    Image.asset(
                      "assets/images/helps/help3-3.jpg",
                      height: 200.h,
                      width: 200.w,
                    )
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Kemudian akan muncul icon tempat sampah dibagian atas aplikasi"),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help3-4.jpg",
                      height: 150.h,
                      width: 150.w,
                    ),
                    Image.asset(
                      "assets/images/helps/help3-7.jpg",
                      height: 150.h,
                      width: 150.w,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Tekan icon tempat sampah tersebut. Konfirmasi apakah kamu benar-benar akan menghapus timer tersebut"),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help3-5.jpg",
                      height: 300.h,
                      width: 300.w,
                    )
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                  desc: "Maka timer akan dihapus dari daftar timermu",
                ),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help3-6.jpg",
                      height: 300.h,
                      width: 300.w,
                    )
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
