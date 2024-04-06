import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/list_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/widgets/home_rekomendasi_tile.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  late List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isSettingPressed = false;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  List<Color> labelColors = [offOrange, cetaceanBlue, cetaceanBlue];

  void updateLabelColors(int selectedIndex) {
    for (int i = 0; i < labelColors.length; i++) {
      labelColors[i] = cetaceanBlue;
    }
    labelColors[selectedIndex] = offOrange;
  }

  // refresh data
  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      _counter = existingData['time'] ?? 0;
      _counterBreakTime = existingData['rest'] ?? 0;
      _counterInterval = existingData['interval'] ?? 0;
    } else {
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      _counter = 0;
      _counterBreakTime = 0;
      _counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 170),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: DisplayModal(id: id),
      ),
    );
    onClose(newData);
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ripeMango,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 69.0,
        items: [
          CurvedNavigationBarItem(
            child: SvgPicture.asset(
              "assets/images/solar.svg",
              width: 25,
              height: 25,
            ),
            label: "BERANDA",
            labelStyle: TextStyle(
              color: labelColors[0],
              fontFamily: 'Nunito',
            ),
          ),
          CurvedNavigationBarItem(
            child: const Icon(
              Icons.add,
              size: 25,
            ),
            label: "TAMBAH",
            labelStyle: TextStyle(
              color: labelColors[1],
              fontFamily: 'Nunito',
            ),
          ),
          CurvedNavigationBarItem(
            child: const Icon(
              Icons.hourglass_empty_rounded,
              size: 25,
            ),
            label: "TIMER",
            labelStyle: TextStyle(
              color: labelColors[2],
              fontFamily: 'Nunito',
            ),
          ),
        ],
        backgroundColor: Colors.white,
        color: offOrange,
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 500),
        buttonBackgroundColor: ripeMango,
        onTap: (index) {
          setState(() {
            _page = index;
            updateLabelColors(index);
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                break;
              case 1:
                _showModal((int? id) {});
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailListTimer(),
                  ),
                );
                break;
            }
          });
        },
        letIndexChange: (index) => true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          // SizedBox(height: 10),
          SliverAppBar(
            title: SizedBox.shrink(),
            floating: true, // Membuat app bar tetap muncul saat discroll
            snap: true, // Mengaktifkan efek snap saat discroll
            backgroundColor: ripeMango,
            elevation: 0, // Menghilangkan shadow di app bar
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.translate(
                          offset: const Offset(15, 0),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo Mindy',
                                style: TextStyle(
                                  fontFamily: 'Nunito-Bold',
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
                                    fontFamily: 'Nunito-Bold',
                                    color: Colors.black,
                                    fontSize: 19.68,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'fokusmu hari ini!',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Nunito-Bold',
                                    color: Colors.black,
                                    fontSize: 19.68,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(-20, 10),
                          child: Container(
                            width: 100,
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 10.0),
                            margin: const EdgeInsets.only(top: 15.0),
                            child: SvgPicture.asset(
                              "assets/images/cat3.svg",
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
            ),
            expandedHeight: 200.0, // Tinggi ekspansi maksimum untuk app bar
            pinned: true, // Membuat app bar menempel di bagian atas saat discroll
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 15.0, top: 50.0, right: 15.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/star.svg",
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Rekomendasi",
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: heliotrope,
                              ),
                            ),
                          ],
                        ),
                      ),
                      HomeRekomendasiTile(isSettingPressed: isSettingPressed),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        margin: EdgeInsets.only(left: 8.0, right: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              color: ripeMango,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Timer Mu",
                              style: TextStyle(
                                fontFamily: 'Nunito-Bold',
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: ripeMango,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailListTimer(),
                                  ),
                                );
                              },
                              child: Text(
                                "Lihat Semua",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: ripeMango,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      HomeTimermuTile(isSettingPressed: isSettingPressed),
                    ],
                  ),
                );
              },
              childCount: 1, // Hanya satu item dalam SliverList
            ),
          ),
        ],
      ),
    );
  }
}