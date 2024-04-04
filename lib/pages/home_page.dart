import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/detail_list_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/home_rekomendasi_tile.dart';
import 'package:mobile_time_minder/widgets/home_timermu_tile.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

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
      // Jika data baru, reset nilai controller
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
      // Ini sementara buat percobaan bottom navigation (diisi sama Rifqi)
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.plus_one), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Diisi sama Rifqi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Hi, Mindy
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo Mindy',
                            style: TextStyle(
                              fontFamily: 'Nunito-Bold',
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Yuk, capai target fokusmu hari ini',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),

                      // Gambar Mindy
                      SvgPicture.asset(
                        'assets/images/cat3.svg',
                        height: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.only(left: 15.0, top: 50.0, right: 15.0),
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
                    HomeRekomendasiTile(),
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
                    HomeTimermuTile(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal((int? id) {}),
        child: Icon(Icons.add),
      ),
    );
  }
}
