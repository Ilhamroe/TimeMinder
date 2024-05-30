import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/services/onboarding_routes.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/modal_timer/alert_data.dart';
import 'package:time_minder/widgets/modal_timer/button_execute.dart';
import 'package:time_minder/widgets/modal_timer/cupertino_switch.dart';
import 'package:time_minder/widgets/modal_timer/custom_text.dart';
import 'package:time_minder/widgets/modal_timer/setting_break.dart';
import 'package:time_minder/widgets/modal_timer/setting_time.dart';

class ModalAdd extends StatefulWidget {
  const ModalAdd({super.key, this.id});
  final int? id;

  @override
  State<ModalAdd> createState() => _ModalAddState();
}

class _ModalAddState extends State<ModalAdd> {
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

  void _submitSetting() async {
    final name = namaTimerController.text.trim();
    final description = deskripsiController.text.trim();
    final counter = _counter;
    if (name.isEmpty || description.isEmpty || counter == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertData();
        },
      );
    } else {
      if (id == null) {
        await _addData().then((data) => _refreshData());
        Navigator.popAndPushNamed(context, AppRoutes.navbar);
      } else {
        await _updateData(id!).then((value) => _refreshData());
        Navigator.popAndPushNamed(context, AppRoutes.navbar);
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertData();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20).w,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0).w,
          ),
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(26, 15, 26, 21).w,
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
                        fontSize: 15.5.sp,
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
                SizedBox(height: 6.4.h),
                const CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  maxLength: 20,
                  maxLines: 1,
                  controller: namaTimerController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: 6.4.h),
                const CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: 6.4.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextField(
                        labelText: "Waktu Fokus (dalam menit)"),
                    SizedBox(height: 15.h),
                    SettingTimeWidget(
                      key: _settingTimeWidgetKey,
                      initialCounter: _counter,
                      onChanged: _handleTimerChange,
                    ),
                    SizedBox(height: 10.h),
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
                                  width: 28.w,
                                  height: 28.h,
                                )
                              : SvgPicture.asset(
                                  "assets/images/option.svg",
                                  width: 28.w,
                                  height: 28.h,
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
                          SizedBox(height: 9.1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CustomTextField(
                                  labelText: "Aktifkan mode istirahat"),
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
                          SizedBox(height: 9.1.h),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Expanded(
                                    child: CustomTextField(
                                        labelText: "Durasi Istirahat"),
                                  ),
                                  SizedBox(width: 15.w),
                                  const Expanded(
                                    child: CustomTextField(
                                        labelText: "Jumlah Istirahat"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.6.h),
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
                    SizedBox(height: 10.4.h),
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
                        SizedBox(width: 14.6.w),
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
