import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
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
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isOptionOpen = false;

  TextEditingController namaTimerController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  //databases
  late List<Map<String, dynamic>> _allData = [];

  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      isLoading = false;
    });
  }

  // show data by id
  void getSingleData(int id) async {
    final data = await SQLHelper.getSingleData(id);
    final int timerValue = data[0]['timer'] ?? 0;

    setState(() {
      namaTimerController.text = data[0]['title'];
      deskripsiController.text = data[0]['description'];
      _counter = timerValue;
      _counterBreakTime = data[0]['rest'] ?? 0;
      _counterInterval = data[0]['interval'] ?? 0;
    });
  }

  late OverlayEntry _overlayEntry;
  void _showOverlay(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = 10.0;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight,
        left: horizontalPadding,
        right: horizontalPadding,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: screenWidth - (horizontalPadding * 2),
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: verticalPadding),
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Nama Timer, Deskripsi, dan Waktu harus diisi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                color: pureWhite,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context)!.insert(_overlayEntry);
  }

  void _submitSetting() async {
    final name = namaTimerController.text.trim();
    final description = deskripsiController.text.trim();
    final counter = _counter;

    if (name.isEmpty || description.isEmpty || counter == 0) {
      _showOverlay(context);
      Future.delayed(Duration(seconds: 1), () {
        _overlayEntry.remove();
      });
      return;
    }

    if (id == null) {
      await _addData().then((data) => _refreshData());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      await _updateData(id!).then((value) => _refreshData());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailListTimer(),
        ),
      );
    }

    setState(() {
      _counter = _settingTimeWidgetKey.currentState?.getCounter() ?? 0;
    });
  }

  void _resetSetting() {
    setState(() {
      namaTimerController.clear();
      deskripsiController.clear();
      _settingTimeWidgetKey.currentState?.resetCounter();
      _settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
    });
  }

  void _handleTimerChange(int value) {
    setState(() {
      _counter = value;
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

  void _openAnotherOption() {
    if (namaTimerController.text.isNotEmpty &&
        deskripsiController.text.isNotEmpty &&
        _counter != 0) {
      setState(() {
        isOptionOpen = !isOptionOpen;
        hideContainer = !hideContainer;
        statusSwitch = false;
      });
    } else {
      _showOverlay(context);
      Future.delayed(
        Duration(seconds: 1),
        () {
          _overlayEntry?.remove();
        },
      );
    }
  }

  // add data
  Future<void> _addData() async {
    await SQLHelper.createData(
        namaTimerController.text,
        deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
    _refreshData();
  }

  // edit data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        namaTimerController.text,
        deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;
    if (id != null) {
      getSingleData(id!);
    }
  }

  @override
  void dispose() {
    namaTimerController.dispose();
    deskripsiController.dispose();
    _overlayEntry.remove();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    final double horizontalPadding = screenWidth * 0.05;
    final double verticalPadding = screenHeight * 0.03;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: screenWidth * 0.9,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            verticalPadding,
          ),
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
                        fontSize: screenWidth * 0.04,
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
                SizedBox(height: screenHeight * 0.01),
                CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  maxLength: 20,
                  maxLines: 1,
                  controller: namaTimerController,
                  decoration: InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: deskripsiController,
                  decoration: InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(labelText: "Waktu Fokus (dalam menit)"),
                    SizedBox(height: screenHeight * 0.015),
                    SettingTimeWidget(
                      key: _settingTimeWidgetKey,
                      initialCounter: _counter,
                      onChanged: _handleTimerChange,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: CustomTextField(labelText: "Opsi Lainnya"),
                        ),
                        IconButton(
                          onPressed: () => _openAnotherOption(),
                          icon: isOptionOpen
                              ? SvgPicture.asset(
                                  "assets/images/option_up.svg",
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                )
                              : SvgPicture.asset(
                                  "assets/images/option.svg",
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
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
                          SizedBox(height: screenHeight * 0.01),
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
                          SizedBox(height: screenHeight * 0.01),
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
                                  SizedBox(width: screenWidth * 0.02),
                                  Expanded(
                                    child: CustomTextField(
                                        labelText: "Jumlah Istirahat"),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.005),
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
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomButton(
                          text: '  Reset  ',
                          primaryColor: Colors.white,
                          onPrimaryColor: cetaceanBlue,
                          borderSideColor: cetaceanBlue,
                          onPressed: _resetSetting,
                        ),
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
