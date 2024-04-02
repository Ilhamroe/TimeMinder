import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _page=0;
  final GlobalKey<CurvedNavigationBarState>_bottomNavigationKey= GlobalKey();

  List<Color>labelColors=[
      const Color.fromARGB(255, 250, 227, 176),
      Colors.black,
      Colors.black
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 76.0,
        items: [
            CurvedNavigationBarItem(
              child: SvgPicture.asset("assets/images/solar.svg",width: 35, height: 35),
              label: "BERANDA", labelStyle: TextStyle(color: labelColors[0])
          ),
            CurvedNavigationBarItem(
              child: const Icon(Icons.add, size: 35),
              label:  "TAMBAH", labelStyle: TextStyle(color: labelColors[1])
          ),
            CurvedNavigationBarItem(
              child: const Icon(Icons.hourglass_empty_rounded, size: 35),
              label:  "TIMER", labelStyle: TextStyle(color: labelColors[2])
          ),
        ],   
        backgroundColor: Colors.white,
        color: const Color(0xFFFFF8E8),
        // animationCurve: Curves.bounceInOut,       
        // animationDuration: const Duration(milliseconds: 500),
        buttonBackgroundColor: const Color(0xFFFFBF1C),
        onTap: (index) {
          setState(() {
              _page= index;
              updateLabelColors(index);


              //GANTI KODE INI DENGAN PAGES ANDA
              // switch(index){
              //   case 0:
              //   Navigator.pushReplacement(
              //     context, 
              //     MaterialPageRoute(builder: (context) => const HomePage()),
              //     );
              //   break;
                
              //   case 1:
              //   Navigator.pushReplacement(
              //     context, 
              //     MaterialPageRoute(builder: (context) => const Minum()),
              //     );
              //   break;

              //   case 2:
              //   Navigator.pushReplacement(
              //     context, 
              //     MaterialPageRoute(builder: (context) => const Tidur()),
              //     );
              //   break;
              // }
          });
        },
        letIndexChange: (index) => true,
      ),
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      
                      children: [
                        // Hi, Mindy
                        Transform.translate(
                          offset: const Offset(15, 0),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo Mindy',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 31.55,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Yuk, capai target',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.68,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                'fokusmu hari ini!',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.68,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
          
                        // Gambar Mindy

                        Transform.translate(
                          offset: const Offset(-20, 10),
                          child: Container(
                            
                              width: 100,
                              padding: const EdgeInsets.only(top: 5.0,bottom: 10.0),
                              margin: const EdgeInsets.only(top: 15.0),                          
                              child: SvgPicture.asset("assets/images/cat3.svg",
                              width: 150.0,
                              height: 150.0,
                            ),                         
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(25),
                               
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  ),  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateLabelColors(int selectedIndex){
      for(int i=0; i<labelColors.length; i++){
        labelColors[i]= Colors.black;
      }
      labelColors[selectedIndex]= const Color.fromARGB(255, 250, 227, 176);
  }
}
