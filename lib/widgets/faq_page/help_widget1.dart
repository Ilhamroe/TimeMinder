import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/help_content.dart';
import 'package:time_minder/widgets/common/slide_image.dart';
import 'package:time_minder/widgets/common/spacing.dart';

class HelpOne extends StatefulWidget {
  const HelpOne({super.key});

  @override
  State<HelpOne> createState() => _HelpOneState();
}

class _HelpOneState extends State<HelpOne> with TickerProviderStateMixin {
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
    // final Size screenSize = MediaQuery.of(context).size;
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
            "Menggunakan Fitur Custom Timer",
            style: TextStyle(
              fontFamily: 'Nunito_bold',
              fontSize: 19.sp,
            ),
          ),
          centerTitle: true,
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
                      "Bagaimana saya menambahkan timer dengan custom waktu istirahat?",
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
                const CustomSpace(),
                const HelpContent(
                    desc:
                        "Untuk menambahkan timer, kamu hanya perlu pergi ke tombol plus pada navigation bar yang ada pada bagian bawah aplikasi."),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help1-1.jpg",
                      width: 300.w,
                      height: 100.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Tekan tombol tersebut maka akan muncul modal dengan beberapa form yang harus kamu isi: "),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                      image: "assets/images/helps/help1-2.jpg",
                      offsetAnimation: offsetAnimation,
                      height: 200.h,
                      width: 200.w,
                    ),
                    const Flexible(
                        child: HelpContentRight(
                            desc:
                                "Masukkan nama timer kamu dan deskripsi dari timer tersebut")),
                  ],
                ),
                const BigSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: HelpContent(
                          desc: "Masukkan durasi waktu fokus yang kamu mau"),
                    ),
                    SlideImage(
                      image: "assets/images/helps/help1-3.jpg",
                      offsetAnimation: offsetAnimation2,
                      height: 200.h,
                      width: 200.w,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                  desc:
                      "Jika kamu ingin menambahkan waktu istirahat sesuai dengan preferensimu, tekan tombol panah berikut untuk membuka additional option",
                ),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help1-4.jpg",
                      width: 300.w,
                      height: 300.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                  desc:
                      "Tekan radio button untuk mengaktifkan mode istirahat kemudian masukkan durasi istirahat dan jumlah waktu istirahat yang kamu mau",
                ),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help1-5.jpg",
                      width: 300.w,
                      height: 300.h,
                    ),
                  ],
                ),
                const BigSpace(),
                const HelpContent(
                    desc:
                        "Setelah mengatur durasi fokus dan waktu istirahat, klik “Terapkan” untuk menambahkan ke daftar timermu"),
                const CustomSpace(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/helps/help1-6.jpg",
                      width: 300.w,
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
