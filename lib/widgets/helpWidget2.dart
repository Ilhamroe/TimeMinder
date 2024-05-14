import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/widgets/helpWidget1.dart';

class HelpTwo extends StatefulWidget {
  const HelpTwo({super.key});

  @override
  State<HelpTwo> createState() => _HelpTwoState();
}

class _HelpTwoState extends State<HelpTwo> with TickerProviderStateMixin{
  late AnimationController _controller2;
  late Animation<Offset> offsetAnimation2;

   @override
  void initState() {
    super.initState();
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
          "Mengedit Timer",
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
                    child: Text(
                      "Bagaimana jika saya ingin mengedit timer yang telah saya tambahkan?", 
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.0425,
                    fontWeight: FontWeight.bold),)),
                ],
              ),
              const CustomSpace(),
              const HelpContent(
                desc: "Jika kamu ingin mengedit atau menghapus timer yang telah kamu tambahkan sebelumnya, pergi ke menu “Timer” pada navigation bar yang terletak di bagian bawah aplikasi."
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/help/help2-1.png"),
                ],
              ),
              const BigSpace(),
              const HelpContent(
                desc: "Pada menu ini akan terlihat beberapa timer yang telah kamu tambahkan sebelumnya."
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideImage(
                      image: "assets/images/help/help2-2.png", 
                      offsetAnimation: offsetAnimation2, 
                      width: 350, 
                      height: 350
                    ),
                  ],
                ),
                const BigSpace(),
                Row(
                  children: [
                    const Flexible(
                      child: HelpContent(desc: "Untuk mengedit, tap lama atau hold salah satu timer yang ingin kamu edit")),
                    Image.asset("assets/images/help/help2-3.png", height: 200, width: 200,)
                  ],
                ),
                const BigSpace(),
                 Row(
                  children: [
                    Image.asset("assets/images/help/help2-4.png", height: 200, width: 200,),
                    const Flexible(
                      child: HelpContentRight(desc: "Kemudian akan muncul icon edit di bagian atas aplikasi", )),
                  ],
                ),  
                const BigSpace(),
                Row(
                  children: [
                    const Flexible(
                      child: HelpContent(desc: "Untuk menghapus, tap lama atau hold salah satu timer yang ingin kamu hapus")),
                    Image.asset("assets/images/help/help2-3.png", height: 200, width: 200,)
                  ],
                ),
                const BigSpace(),
                Row(
                  children: [
                    Image.asset("assets/images/help/help2-4.png", height: 200, width: 200,),
                    const Flexible(
                      child: HelpContentRight(desc: "Kemudian akan muncul icon tempat sampah dibagian atas aplikasi")),
                  ],
                ),
              const BigSpace(),
              const HelpContent(
                desc: "Tekan icon tempat sampah tersebut. Konfirmasi apakah kamu benar-benar akan menghapus timer tersebut"
                ),  
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/help/help2-5.PNG", height: 250, width: 250,)
                ],
              ),
              const CustomSpace(),
              const HelpContent(desc: "Maka timer akan dihapus dari daftar timermu"),
              const BigSpace(),
              const BigSpace(),
            ],
          ),
        ),
      ),
    );
  }
}