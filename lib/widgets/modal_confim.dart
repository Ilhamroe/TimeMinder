import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/theme.dart';
import 'package:mobile_time_minder/models/notif.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin= FlutterLocalNotificationsPlugin();

typedef ModalCloseCallback = void Function(int? id);

class ModalConfirm extends StatefulWidget {
  final Function()? onConfirm;

  const ModalConfirm({Key? key, this.onConfirm}) : super(key: key);

  @override
  State<ModalConfirm> createState() => _ModalConfirmState();
}

class _ModalConfirmState extends State<ModalConfirm> {
  late List<Map<String, dynamic>> _allData = [];

  bool isLoading = false;
  bool statusSwitch = false;
  final player= AudioPlayer();

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

  void _showNotification(String message) {
    int generateRandomId() {
      return DateTime.now().millisecondsSinceEpoch.remainder(100000);
    }
    Notif.showBigTextNotification(
        id: generateRandomId(),
        title: "TimeMinder",
        body: message,
        fln: flutterLocalNotificationsPlugin);
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
        width: MediaQuery.of(context).size.width * 0.68,
        height: MediaQuery.of(context).size.height * 0.42,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset(
                'assets/images/confirm_popup.png',
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
            const Text(
              "Kembali ke Beranda,",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Apakah Anda yakin?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 21,
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
                        _showNotification("Timer dihentikan");               
                        _refreshData();
                        Navigator.push(
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
