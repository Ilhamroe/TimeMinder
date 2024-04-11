import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/pages/timer_page.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/widgets/setting_break.dart';

class ModalCustomTimer extends StatefulWidget {
  const ModalCustomTimer({Key? key, this.id}) : super(key: key);
  final int? id;

  @override
  State<ModalCustomTimer> createState() => _ModalCustomTimerState();
}

class _ModalCustomTimerState extends State<ModalCustomTimer> {
  int? id;
  int _counter = 0;
  bool isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;
  bool isOptionOpen = false;

  TextEditingController namaTimerController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  late int _counterMainTime;
  TextEditingController _textController = TextEditingController();
  int _counterBreakTime = 0;
  int _counterInterval = 0;

  //databases
  late List<Map<String, dynamic>> _allData = [];
  void _increment() {
    setState(() {
      _counterMainTime++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counterMainTime > 0) {
        _counterMainTime--;
      }
    });
  }

  void _increment1() {
    setState(() {
      _counterBreakTime++;
    });
  }

  void _decrement1() {
    setState(() {
      if (_counterBreakTime > 0) {
        _counterBreakTime--;
      }
    });
  }

  void _increment2() {
    setState(() {
      _counterInterval++;
    });
  }

  void _decrement2() {
    setState(() {
      if (_counterInterval > 0) {
        _counterInterval--;
      }
    });
  }

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
    Overlay.of(context)!.insert(_overlayEntry);
  }

  void _submitSetting() async {
    final name = namaTimerController.text.trim();
    final description = deskripsiController.text.trim();
    final counter = _counter;

    if (name.isEmpty || description.isEmpty || counter == 0) {
      _showOverlay(context);
      Future.delayed(const Duration(seconds: 1), () {
        _overlayEntry.remove();
      });
      return;
    }

    if (id == null) {
      await _addData().then((data) => _refreshData());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      await _updateData(id!).then((value) => _refreshData());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DetailListTimer(),
        ),
      );
    }
  }

  void _resetSetting() {
    setState(() {
      namaTimerController.clear();
      deskripsiController.clear();
      _counterMainTime = 0;
      _counterBreakTime = 0;
      _counterInterval = 0;
      _textController.clear();
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
    _textController.dispose();
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
                    const Expanded(
                      child: Text(
                        "Tambah waktumu sendiri",
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 16,
                        ),
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
                SizedBox(height: screenHeight * 0.01),
                const Text(
                  "Nama Timer : ",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                  ),
                ),
                TextField(
                  maxLength: 20,
                  maxLines: 1,
                  controller: namaTimerController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                const Text(
                  "Deskripsi :",
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                  ),
                ),
                TextField(
                  maxLength: 30,
                  maxLines: 1,
                  controller: deskripsiController,
                  decoration: const InputDecoration(
                    counterText: '',
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Waktu Fokus (dalam menit)",
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: offYellow,
                              border: Border.all(
                                color: ripeMango,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: offYellow,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _decrement,
                                      icon: const Icon(Icons.remove),
                                      iconSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      color: ripeMango,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextFormField(
                                    controller: _textController,
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.035,
                                      color: darkGrey,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: offYellow,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: _increment,
                                      icon: const Icon(Icons.add),
                                      iconSize:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      color: ripeMango,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Opsi Lainnya",
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 14,
                          ),
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
                      duration: const Duration(milliseconds: 500),
                      height: hideContainer ? 0 : null,
                      child: Column(
                        children: [
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                "Aktifkan Mode Istirahat",
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                child: CupertinoTheme(
                                  data: const CupertinoThemeData(
                                    primaryColor: Color(0xFFFFBF1C),
                                    scaffoldBackgroundColor: Color(0xFFC4C5C4),
                                  ),
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: CupertinoSwitch(
                                      value: statusSwitch,
                                      onChanged: (value) {
                                        setState(() {
                                          statusSwitch = !statusSwitch;
                                        });
                                      },
                                      activeColor: const Color(0xFFFFBF1C),
                                      trackColor: const Color(0xFFC4C5C4),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    "Durasi Istirahat",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  const Text(
                                    "Jumlah Istirahat",
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            statusSwitch ? offYellow : offGrey,
                                        border: Border.all(
                                          color: statusSwitch
                                              ? ripeMango
                                              : halfGrey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: IconButton(
                                              onPressed: statusSwitch
                                                  ? _decrement1
                                                  : null,
                                              icon: const Icon(Icons.remove),
                                              iconSize: 16,
                                              color: statusSwitch
                                                  ? ripeMango
                                                  : const Color(0xFF838589),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '$_counterBreakTime',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF838589),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              onPressed: statusSwitch
                                                  ? _increment1
                                                  : null,
                                              icon: const Icon(Icons.add),
                                              iconSize: 16,
                                              color: statusSwitch
                                                  ? ripeMango
                                                  : const Color(0xFF838589),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color:
                                            statusSwitch ? offYellow : offGrey,
                                        border: Border.all(
                                          color: statusSwitch
                                              ? ripeMango
                                              : halfGrey,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: IconButton(
                                              onPressed: statusSwitch
                                                  ? _decrement2
                                                  : null,
                                              icon: const Icon(Icons.remove),
                                              iconSize: 16,
                                              color: statusSwitch
                                                  ? ripeMango
                                                  : const Color(0xFF838589),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '$_counterInterval',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF838589),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            child: IconButton(
                                              onPressed: statusSwitch
                                                  ? _increment2
                                                  : null,
                                              icon: const Icon(Icons.add),
                                              iconSize: 16,
                                              color: statusSwitch
                                                  ? ripeMango
                                                  : const Color(0xFF838589),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                        ElevatedButton(
                          onPressed: _resetSetting,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(pureWhite),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(cetaceanBlue),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                width: 1,
                                color: cetaceanBlue,
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.025,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.12,
                            ),
                            child: const Text("Reset"),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _resetSetting,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(ripeMango),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(pureWhite),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                                width: 1,
                                color: Colors.transparent,
                              ),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero,
                            ),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.025,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.12,
                            ),
                            child: const Text("Terapkan"),
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
