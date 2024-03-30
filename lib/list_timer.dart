import 'package:flutter/material.dart';
import 'package:list_timer/theme.dart';
import 'package:list_timer/widgets/timer_view.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ListTimer extends StatefulWidget {
  const ListTimer({super.key});

  @override
  State<ListTimer> createState() => _ListTimerState();
}

class _ListTimerState extends State<ListTimer>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isSemuaSelected =
      true; // Menyimpan status apakah "Semua" dipilih atau tidak
  bool isSettingPressed =
      false; // Menyimpan status apakah tombol "Setting" ditekan atau tidak

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
        title: Text(
          "Timer",
          style: TextStyle(color: catcBlue),
        ),
        leading: IconButton(
          key: const Key('back'),
          icon: Icon(Icons.arrow_circle_left_outlined, color: catcBlue),
          iconSize: 30,
          onPressed: () {
            logger.d('kembali_tapped');
          },
        ),
        actions: [
          IconButton(
            key: const Key('setting'),
            icon: Icon(Icons.settings_suggest, color: catcBlue),
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
                isSemuaSelected = index ==
                    0; // Ketika "Semua" dipilih, nilai isSemuaSelected menjadi true
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
                    color: isSemuaSelected ? ripeMango : customGrey,
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
                    color: isSemuaSelected ? customGrey : ripeMango,
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
            indicator: BoxDecoration(
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
            TimerView(
                isSettingPressed:
                    isSettingPressed), // Pass isSettingPressed to TimerView
            TimerView(
                isSettingPressed:
                    isSettingPressed), // Pass isSettingPressed to TimerView
          ],
        ),
      ),
    );
  }
}
