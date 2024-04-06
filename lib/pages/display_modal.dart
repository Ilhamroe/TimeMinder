import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/cupertino_switch.dart';
import 'package:mobile_time_minder/widgets/text.dart';
import 'package:mobile_time_minder/widgets/setting_time.dart';
import 'package:mobile_time_minder/widgets/setting_break.dart';
import 'package:mobile_time_minder/widgets/button_exe.dart';

class DisplayModal extends StatefulWidget {
  const DisplayModal({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<DisplayModal> createState() => _DisplayModalState();
}

class _DisplayModalState extends State<DisplayModal> {
  final GlobalKey<SettingTimeWidgetState> _settingTimeWidgetKey =
      GlobalKey<SettingTimeWidgetState>();

  final GlobalKey<SettingBreakWidgetState> _settingBreakWidgetKey =
      GlobalKey<SettingBreakWidgetState>();

  int? id;
  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isOptionOpen = false;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  //databases
  late List<Map<String, dynamic>> _allData = [];

  @override
  void initState() {
    super.initState();
    id = widget.id;
    if (id != null) {
      getSingleData(id!);
    }
  }

  // show data
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

  // show data by id
  void getSingleData(int id) async {
    final data = await SQLHelper.getSingleData(id);
    final int timerValue = data[0]['timer'] ?? 0;

    setState(() {
      _namaTimerController.text = data[0]['title'];
      _deskripsiController.text = data[0]['description'];
      _counter = timerValue;
      _counterBreakTime = data[0]['rest'] ?? 0;
      _counterInterval = data[0]['interval'] ?? 0;
    });
  }

  void _submitSetting() async {
    final name = _namaTimerController.text.trim();
    final description = _deskripsiController.text.trim();
    final counter = _counter;

    if (name.isEmpty || description.isEmpty || counter == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Nama Timer, Deskripsi, dan Waktu harus diisi"),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    if (id == null) {
      await _addData();
    } else {
      await _updateData(id!);
    }

    Navigator.of(context).pop();
  }

  void _resetSetting() {
    setState(() {
      _namaTimerController.clear();
      _deskripsiController.clear();
      _settingTimeWidgetKey.currentState?.resetCounter();
      _settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
    });
  }

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
      isOptionOpen = !isOptionOpen;
      hideContainer = !hideContainer;
      statusSwitch = false;
    });
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

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: screenSize.width * 0.9,
          padding: EdgeInsets.fromLTRB(26, 15, 26, 21),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Tambah waktumu sendiri',
                        fontSize: 16,
                        fontFamily: 'Nunito-Bold',
                      ),
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
                  maxLength: 20,
                  maxLines: 1,
                  controller: _namaTimerController,
                  decoration: InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: 7),
                CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    counterText: '',
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomTextField(labelText: "Opsi Lainnya"),
                        ),
                        IconButton(
                          onPressed: _namaTimerController.text.isNotEmpty &&
                                  _deskripsiController.text.isNotEmpty &&
                                  _counter != 0
                              ? _openIconButtonPressed
                              : null,
                          icon: isOptionOpen
                              ? SvgPicture.asset(
                                  "assets/images/option_up.svg",
                                  width: 30,
                                  height: 30,
                                )
                              : SvgPicture.asset(
                                  "assets/images/option_down.svg",
                                  width: 30,
                                  height: 30,
                                  color: darkGrey,
                                ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    labelText: "Aktifkan mode istirahat"),
                              ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: '  Reset  ',
                          primaryColor: Colors.white,
                          onPrimaryColor: cetaceanBlue,
                          borderSideColor: cetaceanBlue,
                          onPressed: _resetSetting,
                        ),
                        SizedBox(width: 15),
                        CustomButton(
                          text: 'Terapkan',
                          primaryColor: ripeMango,
                          onPrimaryColor: pureWhite,
                          borderSideColor: Colors.transparent,
                          onPressed: _submitSetting,
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
