import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class ModalConfirm extends StatefulWidget {
  final Function()? onConfirm;

  const ModalConfirm({Key? key, this.onConfirm}) : super(key: key);

  @override
  State<ModalConfirm> createState() => _ModalConfirmState();
}

class _ModalConfirmState extends State<ModalConfirm> {
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
      builder: (_) => Container(
        margin: const EdgeInsets.only(top: 170),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: DisplayModal(id: id),
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
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: SizedBox(
        width: 100,
        height: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              "Apakah Anda yakin?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: halfGrey,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Tidak",
                      style: TextStyle(color: offGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: ripeMango,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (widget.onConfirm != null) {
                        widget.onConfirm!();
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Ya",
                      style: TextStyle(color: offGrey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
