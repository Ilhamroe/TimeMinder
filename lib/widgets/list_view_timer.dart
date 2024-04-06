import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/models/timers.dart';
import 'package:mobile_time_minder/pages/custom_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';

class ListTimer extends StatefulWidget {
  const ListTimer({Key? key});

  @override
  State<ListTimer> createState() => _ListTimerState();
}

class _ListTimerState extends State<ListTimer>
    with TickerProviderStateMixin {
  late TabController tabController;
  late List<Map<String, dynamic>> _allData = [];
  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  int selectedIndex = 1;
  bool isPageSemuaSelected = true;
  bool isSettingPressed = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  final TextEditingController _namaTimerController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

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

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
      duration: Duration(milliseconds: 500),
    ));
    _refreshData();
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: timerList.length,
      itemBuilder: (context, index) {
        final timers = timerList[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
          decoration: BoxDecoration(
            color: ripeMango.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: heliotrope,
                      ),
                      child: Center(
                        child: ClipPath(
                          child: Image.asset(
                            timers.image,
                            fit: BoxFit.scaleDown,
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timers.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            timers.timersDesc,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 40.0, top: 20.0),
                            child: Text(timers.timerEstimate,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (!isSettingPressed)
                                IconButton(
                                  iconSize: 20,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  color: blueJeans,
                                  padding: const EdgeInsets.only(
                                      left: 30.0, top: 10),
                                  icon: const Icon(Icons.edit,
                                      size: 15), //Logic edit
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const DisplayModal();
                                      },
                                    );
                                  },
                                ),
                              if (!isSettingPressed)
                                IconButton(
                                  iconSize: 20,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  color: red,
                                  padding: const EdgeInsets.only(
                                      right: 10.0, top: 10),
                                  icon: const Icon(Icons.delete, size: 15),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          content: SizedBox(
                                            width: 100,
                                            height: 300,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 120.0,
                                                  child: Image.asset(
                                                    'assets/images/confirm_popup.png',
                                                    fit: BoxFit.contain,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ),
                                                const Text(
                                                  "Hapus Timer",
                                                  style: TextStyle(
                                                    fontFamily: 'Nunito-Bold',
                                                    fontSize: 18.0,
                                                    color: red,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 10.0),
                                                const Text(
                                                  "Apakah Anda yakin?",
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 20.0),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 80,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: halfGrey,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          // delete logic here
                                                          deleteData(index);
                                                        },
                                                        child: const Text(
                                                          "Ya",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 30),
                                                    Container(
                                                      width: 80,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: ripeMango,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "Tidak",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              if (isSettingPressed)
                                IconButton(
                                  iconSize: 50,
                                  alignment: Alignment.topCenter,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                      right: 20.0, bottom: 10),
                                  icon: Image.asset(
                                    'assets/images/playbutton.png',
                                    fit: BoxFit.contain,
                                    width: 40,
                                    height: 40,
                                  ),
                                  onPressed: () {},
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void deleteData(int index) {
    setState(() {
      timerList.removeAt(index);
    });
  }
}
