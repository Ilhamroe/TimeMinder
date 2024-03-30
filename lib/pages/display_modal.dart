import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/widgets/cupertino_switch.dart';
import 'package:mobile_time_minder/widgets/text.dart';
import 'package:mobile_time_minder/widgets/setting_time.dart';
import 'package:mobile_time_minder/widgets/setting_break.dart';
import 'package:mobile_time_minder/widgets/button_exe.dart';

class DisplayModal extends StatefulWidget {
  const DisplayModal({Key? key}) : super(key: key);

  @override
  State<DisplayModal> createState() => _DisplayModalState();
}

class _DisplayModalState extends State<DisplayModal> {
  final GlobalKey<SettingTimeWidgetState> _settingTimeWidgetKey =
      GlobalKey<SettingTimeWidgetState>();

  final GlobalKey<SettingBreakWidgetState> _settingBreakWidgetKey =
      GlobalKey<SettingBreakWidgetState>();

  //databases
  late List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = true;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // show data
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  // add data
  Future<void> _addData() async {
    await SQLHelper.createData(
      _namaTimerController.text,
      _deskripsiController.text,
      _counter,
      _counterBreakTime,
      _counterInterval,
    );

    Navigator.of(context).pop();
    _refreshData();
  }

  // edit data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        _namaTimerController.text,
        _deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
    Navigator.of(context).pop();
    _refreshData();
  }

  Future<void> _handleBreakTimeChange(int value) async {
    setState(() {
      _counterBreakTime = value;
    });
  }

  Future<void> _handleIntervalChange(int value) async {
    setState(() {
      _counterInterval = value;
    });
  }

  Future<void> _openIconButtonPressed() async {
    setState(() {
      hideContainer = !hideContainer;
      statusSwitch = false;
    });
  }

  Future<void> _resetSetting() async {
    setState(() {
      _namaTimerController.clear();
      _deskripsiController.clear();
      _counter = 0;
      _settingTimeWidgetKey.currentState?.resetCounter();
      _settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
    });
  }

  Future<void> updateCounter(int value) async {
    setState(() {
      _counter = value;
    });
  }

  void _submitButton([int? id]) async {
    final name = _namaTimerController.text.trim();
    final description = _deskripsiController.text.trim();
    final counter = _counter;

    if (name.isEmpty || description.isEmpty || counter == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Nama Timer, Deskripsi, dan Waktu harus diisi"),
      ));
      return;
    }

    if (id == null) {
      await _addData();
    } else {
      await _updateData(id);
    }

    _refreshData();
  }

  void _showModal([int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      _counter = existingData['time'] ?? 0;
      _counterBreakTime = existingData['rest'] ?? 0;
      _counterInterval = existingData['interval'] ?? 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoTheme(
        data: CupertinoThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.redAccent,
        ),
        child: Container(
          margin: EdgeInsets.only(top: 170),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
          ),
          child: DisplayModal(),
        ),
      ),
    );
    if (newData != null) {
      _refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(26, 15, 26, 21),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextField(
                      labelText: 'Tambah waktumu sendiri',
                      fontSize: 21,
                      fontFamily: 'Nunito-Bold',
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  controller: _namaTimerController,
                  maxLength: 20, 
                  decoration: InputDecoration(
                    counterText:
                        '', 
                  ),
                ),
                SizedBox(height: 7),
                CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  controller: _deskripsiController,
                  maxLength: 33, 
                  decoration: InputDecoration(
                    counterText:
                        '', 
                  ),
                ),
                SizedBox(height: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(labelText: "Waktu (dalam menit)"),
                    SizedBox(height: 15),
                    SettingTimeWidget(
                      key: _settingTimeWidgetKey,
                      initialCounter: _counter,
                      onChanged: (value) {
                        setState(() {
                          _counter = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextField(labelText: "Opsi Lainnya"),
                        IconButton(
                          onPressed: _namaTimerController.text.isNotEmpty &&
                                  _deskripsiController.text.isNotEmpty &&
                                  _counter != 0
                              ? _openIconButtonPressed
                              : null,
                          icon: Icon(Icons.arrow_drop_down_circle_outlined,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: hideContainer ? 0 : null,
                      child: Column(
                        children: [
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomTextField(
                                  labelText: "Aktifkan Mode Belajar"),
                              CupertinoSwitchAdaptiveWidget(
                                statusSwitch: statusSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    statusSwitch = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                        labelText: "Durasi Istirahat"),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: CustomTextField(
                                        labelText: "Jumlah Istirahat"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              SettingBreakWidget(
                                key: _settingBreakWidgetKey,
                                statusSwitch: statusSwitch,
                                onBreakTimeChanged: _handleBreakTimeChange,
                                onIntervalChanged: _handleIntervalChange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        CustomButton(
                          text: '  Reset  ',
                          primaryColor: Colors.white,
                          onPrimaryColor: Color(0xFF030A30),
                          borderSideColor: Color(0xFF030A30),
                          onPressed: _resetSetting,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: 'Terapkan',
                          primaryColor: Color(0xFFFFBF1C),
                          onPrimaryColor: Color.fromARGB(255, 254, 254, 254),
                          borderSideColor: Colors.transparent,
                          onPressed: _submitButton,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
