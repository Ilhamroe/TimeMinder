import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/detail_custom_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/modal_confim.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomeTimermuTile extends StatefulWidget {
  final bool isSettingPressed;

  const HomeTimermuTile({Key? key, required this.isSettingPressed})
      : super(key: key);

  @override
  State<HomeTimermuTile> createState() => _HomeTimermuTileState();
}

class _HomeTimermuTileState extends State<HomeTimermuTile> {
  final List<Color> _customColors = [
    blueJeans,
    ripeMango,
    darkGrey,
    heliotrope,
    red,
  ];

  //databases
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
    if (mounted) {
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
      builder: (_) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          // Modal content
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 170),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70),
              ),
              child: DisplayModal(id: id),
            ),
          ),
        ],
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: _allData.length,
            itemBuilder: (context, int index) {
              final color = _customColors[index % _customColors.length];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTimer(data: _allData[index]),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 13.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: offOrange,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 15.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        color: color,
                        child: SvgPicture.asset(
                          'assets/images/cat1.svg',
                          height: 30,
                        ),
                      ),
                    ),
                    title: Text(
                      _allData[index]['title'],
                      style: const TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      _allData[index]['description'],
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    trailing: widget.isSettingPressed
                        ? SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          alignment: Alignment.topCenter,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          color: ripeMango,
                                          icon: const Icon(
                                              CupertinoIcons.pencil_circle_fill,
                                              size: 26),
                                          onPressed: () => _showModal(
                                              (int? id) {},
                                              _allData[index]['id']),
                                        ),
                                        IconButton(
                                          alignment: Alignment.topCenter,
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          color: redDeep,
                                          icon: const Icon(
                                              CupertinoIcons.delete_solid,
                                              size: 26),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  content: SizedBox(
                                                    width: 100,
                                                    height: 300,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
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
                                                          "Timer akan dihapus,",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 21,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                            const Text(
                                                          "Apakah Anda yakin?",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Nunito',
                                                            fontSize: 26,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 20.0),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: halfGrey,
                                                              ),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Tidak",
                                                                  style: TextStyle(
                                                                      color:
                                                                          offGrey),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 30),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color:
                                                                    ripeMango,
                                                              ),
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  if (index !=
                                                                      null) {
                                                                    _deleteData(
                                                                        _allData[index]
                                                                            [
                                                                            'id']);
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                  "Ya",
                                                                  style: TextStyle(
                                                                      color:
                                                                          offGrey),
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
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                _formatTime(_allData[index]['timer'] ?? 0),
                                style: const TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                  color: darkGrey,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              SvgPicture.asset(
                                'assets/images/button.svg',
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          );
  }

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String _padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${_padLeft(hours)}:${_padLeft(minutes)}:${_padLeft(seconds)}';
  }
}
