import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_minder/database/db_helper.dart';
import 'package:time_minder/services/onboarding_routes.dart';
import 'package:time_minder/utils/colors.dart';
import 'package:time_minder/widgets/common/field_validator.dart';
import 'package:time_minder/widgets/modal_timer/alert_data.dart';
import 'package:time_minder/widgets/modal_timer/button_execute.dart';
import 'package:time_minder/widgets/modal_timer/cupertino_switch.dart';
import 'package:time_minder/widgets/modal_timer/custom_text.dart';
import 'package:time_minder/widgets/modal_timer/setting_break.dart';
import 'package:time_minder/widgets/modal_timer/setting_time.dart';

class EditModal extends StatefulWidget {
  const EditModal({super.key, this.id});
  final int? id;

  @override
  State<EditModal> createState() => _EditModalState();
}

class _EditModalState extends State<EditModal> {
  final GlobalKey<SettingTimeWidgetState> _settingTimeWidgetKey =
      GlobalKey<SettingTimeWidgetState>();

  final GlobalKey<SettingBreakWidgetState> _settingBreakWidgetKey =
      GlobalKey<SettingBreakWidgetState>();

  int? id;
  late int _counter;
  late int _counterBreakTime;
  late int _counterInterval;
  bool isLoading = false;
  late bool initSwitch = false;
  bool hideContainer = true;
  bool isOptionOpen = false;
  bool isNameEmpty = false;
  bool isDescEmpty = false;
  bool _isCounterZero = false;

  TextEditingController timerNameController = TextEditingController();
  TextEditingController descController = TextEditingController();

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
      timerNameController.text = data[0]['title'];
      descController.text = data[0]['description'];
      _counter = timerValue;
      _counterBreakTime = data[0]['rest'] ?? 0;
      _counterInterval = data[0]['interval'] ?? 0;
      initSwitch = _counterBreakTime != 0 || _counterInterval != 0;
      if (initSwitch) {
        hideContainer = false;
      }
    });

  }

  TextEditingController breakTimeController = TextEditingController();
  TextEditingController intervalController = TextEditingController();

  void setBreakTimeCounter(int value) {
    setState(() {
      _counterBreakTime = value;
    });
  }

  void setIntervalCounter(int value) {
    setState(() {
      _counterInterval = value;
    });
  }

  void _submitSetting() async {
    final name = timerNameController.text.trim();
    final description = descController.text.trim();
    final counter = _counter;
    if (name.isEmpty || description.isEmpty || counter == 0) {
      setState(() {
        isNameEmpty = name.isEmpty;
        isDescEmpty = description.isEmpty;
        _isCounterZero = counter == 0;
      });
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
      timerNameController.clear();
      descController.clear();
      _settingTimeWidgetKey.currentState?.resetCounter();
      _settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
      _isCounterZero = false;
    });
  }

  void _handleTimerChange(int value) {
    setState(() {
      _counter = value;
      if(value != 0) {
        _isCounterZero = false;
      }
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
    if (timerNameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        _counter != 0) {
      setState(() {
        isOptionOpen = !isOptionOpen;
        hideContainer = !hideContainer;
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
        timerNameController.text,
        descController.text,
        _counter,
        _counterBreakTime,
        _counterInterval,
        );
    _refreshData();
  }

  // edit data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        timerNameController.text,
        descController.text,
        _counter,
        _counterBreakTime,
        _counterInterval,
        );
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    id = widget.id;
    if (id != null) {
      getSingleData(id!);
    }
    timerNameController.addListener(() {
      if (timerNameController.text.isNotEmpty && isNameEmpty) {
        setState(() {
          isNameEmpty= false;
        });
      }
    });
    descController.addListener(() {
      if (descController.text.isNotEmpty && isDescEmpty) {
        setState(() {
          isDescEmpty = false;
        });
      }
    });
    if(initSwitch){
      hideContainer = false;
    }
  }

  @override
  void dispose() {
    timerNameController.dispose();
    descController.dispose();
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
                  controller: timerNameController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                FieldValidator(
                  isFieldEmpty: isNameEmpty, 
                  desc: "Nama harus diisi"
                ),
                SizedBox(height: 6.4.h),
                const CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: descController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                FieldValidator(
                  isFieldEmpty: isDescEmpty, 
                  desc: "Deskripsi harus diisi"
                ),
                const SizedBox(height: 6.4),
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
                    if(_isCounterZero)
                      const FieldValidator(
                        isFieldEmpty: true, 
                        desc: "Angka tidak boleh 0"
                      ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: CustomTextField(labelText: "Opsi Lainnya"),
                        ),
                        IconButton(
                          onPressed: () {_openAnotherOption();
                                    debugPrint('initSwitch: $initSwitch');
                                    debugPrint('hideContainer: $hideContainer');
                          },
                          icon: !hideContainer
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
                                labelText: "Aktifkan mode istirahat",
                              ),
                              const Spacer(),
                              CupertinoSwitchAdaptiveWidget(
                                statusSwitch: initSwitch,
                                onChanged: (value) {
                                  setState(() {
                                    initSwitch = value;
                                    // if(!initSwitch){
                                    //   _resetBreak();
                                    // }
                                    debugPrint('initSwitch: $initSwitch');
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
                                statusSwitch: initSwitch,
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
                            text: '  Reset  ',
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
