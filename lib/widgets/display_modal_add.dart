import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/alert_data.dart';
import 'package:mobile_time_minder/widgets/cupertino_switch.dart';
import 'package:mobile_time_minder/widgets/text.dart';
import 'package:mobile_time_minder/widgets/setting_time.dart';
import 'package:mobile_time_minder/widgets/setting_break.dart';
import 'package:mobile_time_minder/widgets/button_exe.dart';

class DisplayModalAdd extends StatefulWidget {
  const DisplayModalAdd({super.key, this.id});
  final int? id;

  @override
  State<DisplayModalAdd> createState() => _DisplayModalAddState();
}

class _DisplayModalAddState extends State<DisplayModalAdd> {
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
  late List<Map<String, dynamic>> allData = [];

  void _refreshData() async {
    setState(() {
      isLoading = true;
    });
    final List<Map<String, dynamic>> data = await SQLHelper.getAllData();
    setState(() {
      allData = data;
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.01;

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
            child: const Text(
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
    Overlay.of(context).insert(_overlayEntry);
  }

  void _submitSetting() async {
    final name = namaTimerController.text.trim();
    final description = deskripsiController.text.trim();
    final counter = _counter;
    if (name.isEmpty || description.isEmpty || counter == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertData();
        },
      );
    } else {
      if (id == null) {
        await _addData().then((data) => _refreshData());
        Navigator.popAndPushNamed(context, AppRoutes.navbar);
      } else {
        await _updateData(id!).then((value) => _refreshData());
        Navigator.popAndPushNamed(context, AppRoutes.listTimer);
      }
    }
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
        const Duration(seconds: 1),
        () {
          _overlayEntry.remove();
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
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(26, 15, 26, 21),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: CustomTextField(
                        labelText: 'Tambah waktumu sendiri',
                        fontSize: 15.5,
                        fontFamily: 'Nunito-Bold',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6.4),
                const CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  maxLength: 20,
                  maxLines: 1,
                  controller: namaTimerController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 6.4),
                const CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 6.4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextField(
                        labelText: "Waktu Fokus (dalam menit)"),
                    const SizedBox(height: 15),
                    SettingTimeWidget(
                      key: _settingTimeWidgetKey,
                      initialCounter: _counter,
                      onChanged: _handleTimerChange,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: CustomTextField(labelText: "Opsi Lainnya"),
                        ),
                        IconButton(
                          onPressed: () => _openAnotherOption(),
                          icon: isOptionOpen
                              ? SvgPicture.asset(
                                  "assets/images/option_up.svg",
                                  width: 28,
                                  height: 28,
                                )
                              : SvgPicture.asset(
                                  "assets/images/option.svg",
                                  width: 28,
                                  height: 28,
                                  color: darkGrey,
                                ),
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: hideContainer ? 0 : null,
                      child: Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          const SizedBox(height: 9.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextField(
                                    labelText: "Aktifkan mode istirahat",
                                  ),
                                  Text(
                                    "Min 2 menit waktu fokus dan bilangan genap.",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
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
                          const SizedBox(height: 9.1),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
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
                              const SizedBox(height: 14.6),
                              SettingBreakWidget(
                                key: _settingBreakWidgetKey,
                                statusSwitch: statusSwitch,
                                onBreakTimeChanged: _handleBreakTimeChange,
                                onIntervalChanged: _handleIntervalChange,
                                initialBreakTime: _counterBreakTime,
                                initialInterval: _counterInterval,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Reset',
                            primaryColor: Colors.white,
                            onPrimaryColor: cetaceanBlue,
                            borderSideColor: cetaceanBlue,
                            onPressed: _resetSetting,
                          ),
                        ),
                        const SizedBox(width: 14.6),
                        Expanded(
                          child: CustomButton(
                            text: 'Terapkan',
                            primaryColor: ripeMango,
                            onPrimaryColor: pureWhite,
                            borderSideColor: Colors.transparent,
                            onPressed: _submitSetting,
                          ),
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
