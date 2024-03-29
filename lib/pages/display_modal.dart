import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = true;
  bool statusSwitch = false;
  bool hideContainer = true;

  void _handleBreakTimeChange(int value) {
    setState(() {
      _counterBreakTime = value;
    });
  }

  void _handleIntervalChange(int value) {
    setState(() {
      _counterInterval = value;
    });
  }

  void _openIconButtonPressed() {
    setState(() {
      hideContainer = !hideContainer;
      statusSwitch = false;
    });
  }

  void _resetSetting() {
    setState(() {
      _namaTimerController.clear();
      _deskripsiController.clear();
      _counter = 0;
      _settingTimeWidgetKey.currentState?.resetCounter();
      _settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
    });
  }

  void _submitButton([int? id]) async {
    if (id == null) {
      await _addData();
    }
    if (id != null) {
      await _updateData(id);
    }

    _namaTimerController.text = "";
    _deskripsiController.text = "";
    _counter.toString();
    _counterBreakTime.toString();
    _counterInterval.toString();

    Navigator.of(context).pop();
    // _refreshData();
  }

  void updateCounter(int value) {
    setState(() {
      _counter = value;
    });
  }

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  // show data
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // add data
  Future<void> _addData() async {
    await SQLHelper.createData(
        _namaTimerController.text,
        _deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
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
    _refreshData();
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
    ));
    _refreshData();
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
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  controller: _namaTimerController,
                  decoration: InputDecoration(),
                ),
                SizedBox(height: 7),
                CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(),
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
                          icon: Icon(Icons.arrow_drop_down_circle_outlined),
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
