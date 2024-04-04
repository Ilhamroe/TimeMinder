import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/button_exe.dart';
import 'package:mobile_time_minder/widgets/cupertino_switch.dart';
import 'package:mobile_time_minder/widgets/setting_break.dart';
import 'package:mobile_time_minder/widgets/setting_time.dart';
import 'package:mobile_time_minder/widgets/text.dart';

class DisplayModal extends StatefulWidget {
  const DisplayModal({super.key, this.id});
  final int? id;

  @override
  State<DisplayModal> createState() => DisplayModalState();
}

class DisplayModalState extends State<DisplayModal> {
  final GlobalKey<SettingTimeWidgetState> settingTimeWidgetKey =
      GlobalKey<SettingTimeWidgetState>();
  
  final GlobalKey<SettingBreakWidgetState> settingBreakWidgetKey =
      GlobalKey<SettingBreakWidgetState>();

  int? id;
  int counter = 0;
  int counterBreakTime = 0;
  int counterInterval = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController namaTimerController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  //databases
  List<Map<String, dynamic>> allData = [];

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
      isLoading = true;
    });
    final data = await SQLHelper.getAllData();
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
      counter = timerValue;
      counterBreakTime = data[0]['rest'] ?? 0;
      counterInterval = data[0]['interval'] ?? 0;
    });
  }

void _submitSetting() async {
  final name = namaTimerController.text.trim();
  final description = deskripsiController.text.trim();
  final selectedCounter = counter;

  if (name.isEmpty || description.isEmpty || selectedCounter == 0) {
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
  if (mounted){
  Navigator.of(context).pop();
  }
}


  void _resetSetting() {
    setState(() {
      namaTimerController.clear();
      deskripsiController.clear();
      settingTimeWidgetKey.currentState?.resetCounter();
      settingBreakWidgetKey.currentState?.resetCounter();
      hideContainer = true;
    });
  }

  void _handleBreakTimeChange(int value) {
    setState(() {
      counterBreakTime = value;
    });
  }

  void _handleIntervalChange(int value) {
    setState(() {
      counterInterval = value;
    });
  }

  void _openIconButtonPressed() {
    setState(() {
      hideContainer = !hideContainer;
      statusSwitch = false;
    });
  }

  // add data
  Future<void> _addData() async {
    await SQLHelper.createData(
        namaTimerController.text,
        deskripsiController.text,
        counter,
        counterBreakTime,
        counterInterval);
    _refreshData();
  }

  // edit data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        namaTimerController.text,
        deskripsiController.text,
        counter,
        counterBreakTime,
        counterInterval);
    _refreshData();
  }

  // delete data
  void deleteData(int id) async {
    await SQLHelper.deleteData(id);
    if (mounted){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
      duration: Duration(milliseconds: 500),
    ));
    }
    _refreshData();
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
                    const CustomTextField(
                      labelText: 'Tambah waktumu sendiri',
                      fontSize: 18,
                      fontFamily: 'Nunito-Bold',
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                const CustomTextField(labelText: "Nama Timer : "),
                TextField(
                  maxLength: 20,
                  controller: namaTimerController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 7),
                const CustomTextField(labelText: "Deskripsi : "),
                TextField(
                  maxLength: 33,
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextField(labelText: "Waktu (dalam menit)"),
                    const SizedBox(height: 15),
                    SettingTimeWidget(
                      key: settingTimeWidgetKey,
                      initialCounter: counter,
                      onChanged: (value) {
                        setState(() {
                          counter = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTextField(labelText: "Opsi Lainnya"),
                        IconButton(
                          onPressed: namaTimerController.text.isNotEmpty &&
                                  deskripsiController.text.isNotEmpty &&
                                  counter != 0
                              ? _openIconButtonPressed
                              : null,
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const CustomTextField(
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
                          const SizedBox(height: 10),
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
                              const SizedBox(height: 8),
                              SettingBreakWidget(
                                key: settingBreakWidgetKey,
                                statusSwitch: statusSwitch,
                                onBreakTimeChanged: _handleBreakTimeChange,
                                onIntervalChanged: _handleIntervalChange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          flex: 1, // Adjust flex values as needed
                          child: CustomButton(
                            text: '  Reset  ',
                            primaryColor: Colors.white,
                            onPrimaryColor: catcBlue,
                            borderSideColor: catcBlue,
                            onPressed: _resetSetting,
                          ),
                        ),
                        const SizedBox(width: 10), // Add SizedBox for spacing between buttons
                        Expanded(
                          flex: 1, // Adjust flex values as needed
                          child: CustomButton(
                            text: 'Terapkan',
                            primaryColor: ripeMango,
                            onPrimaryColor: catcBlue,
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
