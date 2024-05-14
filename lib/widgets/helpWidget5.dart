import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/widgets/helpWidget1.dart';

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
          "Fitur Detail Timer dan Kalender",
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
                  Flexible(
                    child: Text("Apa itu fitur detail timer dan kalender?", 
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0425,
                    fontWeight: FontWeight.bold),)),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                desc: "Fitur “Detail Timer” dan “Kalender” merupakan fitur baru yang ada pada aplikasi TimeMinder, fitur ini memungkinkan kamu untuk melihat informasi lebih lanjut tentang Timer yang telah kamu jalankan pada hari tersebut."
                ),
              const CustomSpace(),
              const HelpContent(
                desc: "Ini adalah Detail Timer dan Kalender Anda. Jika Anda memilih tanggal dimana Anda tidak menambahkan timer pada hari tersebut, maka Detail Timer menunjukkan bahwa history timer pada hari tersebut kosong."
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help5-1.svg",
                    offsetAnimation: offsetAnimation,
                    width: 450, 
                    height: 450
                  ),
                ],
              ),
              const CustomSpace(),
              const CustomSpace(),
              const HelpContent(
                desc: "Sebaliknya, jika Anda melihat tanggal dimana Anda menambahkan timer pada hari tersebut, maka akan terlihat riwayat timer yang telah Anda tambahkan"
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideImage(
                    image: "assets/images/help/help5-2.svg", 
                    offsetAnimation: offsetAnimation2, 
                    width: 450, 
                    height: 450
                  ),
                ],
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