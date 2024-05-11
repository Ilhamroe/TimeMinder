import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/widgets/helpWidget1.dart';

class HelpFour extends StatefulWidget {
  const HelpFour({super.key});

  @override
  State<HelpFour> createState() => _HelpFourState();
}

class _HelpFourState extends State<HelpFour> with TickerProviderStateMixin {
 late AnimationController _controller;
 late Animation<Offset> offsetAnimation;
 late AnimationController _controller2;
 late Animation<Offset> offsetAnimation2;

   @override
  void initState() {
    super.initState();
    //kiri-kanan
    _controller= AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this
    );
    offsetAnimation= Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller, 
      curve: Curves.easeIn)
    );
    _controller.forward();

    //kanan-kiri
    _controller2= AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this
      );
      offsetAnimation2= Tween<Offset>(
        begin: const Offset(1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller2, 
        curve: Curves.easeIn)
      );
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
    return Scaffold(
        appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          icon: SvgPicture.asset("assets/images/button_back.svg",
          width: 28,
          height: 28,
          )
        ),
        title: Text(
          "Fitur Timer Selesai",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.0525,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.0175,),
              Row(
                children: [
                  Flexible(child: Text("Bagaimana cara saya menghentikan timer yang berjalan?", 
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0425,
                    fontWeight: FontWeight.bold),)),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                desc: "Untuk menghentikan timer yang sedang berjalan, lihat timer yang sedang aktif kemudian klik icon centang."),
                const CustomSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help4-1.png", 
                    offsetAnimation: offsetAnimation, 
                    width: 350, 
                    height: 350
                  ),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                desc: "Akan muncul konfirmasi apakah kamu ingin menghentikan timer atau tidak."
                ),
                const CustomSpace(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help4-2.png", 
                    offsetAnimation: offsetAnimation2, 
                    width: 350, 
                    height: 350
                  ),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                desc: "Tekan “Iya” untuk mengakhiri sesi fokus dan istirahat kamu, maka timer akan berhenti beroperasi."
              ),
              const BigSpace(),
              const BigSpace(),
            ],
          ),
        ),
      ),
    );
  }
}