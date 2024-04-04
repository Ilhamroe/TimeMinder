import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/list_view_timer.dart';
import 'package:logger/logger.dart';

final logger = Logger();
typedef ModalCloseCallback = void Function(int? id);

class ListTimer extends StatefulWidget {
  const ListTimer({super.key});

  @override
  State<ListTimer> createState() => _ListTimerState();
}

class _ListTimerState extends State<ListTimer>
    with SingleTickerProviderStateMixin {

  final List<Color> _customColors = [
    ripeMango,
    offOrange,
    offYellow,
    offGrey,
    heliotrope,
    red,
    blueJeans,
    darkGrey,
    halfGrey,
    catcBlue,
  ];
  Color _getRandomColor() {
    final Random random = Random();
    return _customColors[random.nextInt(_customColors.length)];
  }

  late List<Map<String, dynamic>> _allData = [];

  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // refresh data
  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
      duration: Duration(milliseconds: 500),
    ));
    }
    _refreshData();
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      counter = existingData['time'] ?? 0;
      counterBreakTime = existingData['rest'] ?? 0;
      counterInterval = existingData['interval'] ?? 0;
    } else {
      // Jika data baru, reset nilai controller
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      counter = 0;
      counterBreakTime = 0;
      counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        margin: const EdgeInsets.only(top: 170),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: DisplayModal(id: id),
      ),
    );
    onClose(newData);
    _refreshData();
  }

  late TabController tabController;
  bool isSemuaSelected = true; // Menyimpan status apakah "Semua" dipilih atau tidak
  bool isSettingPressed = false; // Menyimpan status apakah tombol "Setting" ditekan atau tidak

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Timer",
          style: TextStyle(color: catcBlue),
        ),
        leading: IconButton(
          key: const Key('back'),
          icon: const Icon(Icons.arrow_circle_left_outlined, color: catcBlue),
          iconSize: 30,
          onPressed: () {
            logger.d('kembali_tapped');
          },
        ),
        actions: [
          IconButton(
            key: const Key('setting'),
            icon: const Icon(Icons.settings_suggest, color: catcBlue),
            iconSize: 30,
            onPressed: () {
              setState(() {
                isSettingPressed =
                    !isSettingPressed; // Mengubah status ketika tombol "Setting" ditekan
              });
              logger.d('pengaturan_tapped');
            },
          ),
        ],
        backgroundColor: pureWhite,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // mengatur tinggi tabbar
          child: TabBar(
            controller: tabController,
            onTap: (index) {
              setState(() {
                isSemuaSelected = index == 0; // Ketika "Semua" dipilih, nilai isSemuaSelected menjadi true
              });
            },
            tabs: [
              Tab(
                height: 60,
                child: Container(
                  alignment: Alignment.topCenter,
                  height:
                      40, // Adjust the height of the Container to increase TabBar height
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: isSemuaSelected ? ripeMango : halfGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Semua',
                      style: TextStyle(
                          color: isSemuaSelected ? Colors.white : catcBlue),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  alignment: Alignment.topCenter,
                  height:
                      40, // Adjust the height of the Container to increase TabBar height
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: isSemuaSelected ? halfGrey : ripeMango,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Timer Anda',
                      style: TextStyle(
                          color: isSemuaSelected ? catcBlue : Colors.white),
                    ),
                  ),
                ),
              ),
            ],
            indicator: const BoxDecoration(
              color: pureWhite,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: catcBlue,
            splashFactory: NoSplash.splashFactory,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 20.0), // Add space between TabBar and TabBarView
        child: TabBarView(
          controller: tabController,
          children: [
            // ListTimer(isSettingPressed: isSettingPressed), 
            // ListTimer(isSettingPressed: isSettingPressed),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal((int? id) {}),
        child: const Icon(Icons.add),
      ),
    );
  }
}
