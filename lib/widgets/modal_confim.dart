import 'package:flutter/material.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/home_page.dart';
import 'package:mobile_time_minder/services/onboarding_routes.dart';
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

  bool isLoading = false;
  bool statusSwitch = false;

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
      backgroundColor: pureWhite,
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
                        Navigator.popUntil(
                            context, ModalRoute.withName(AppRoutes.home));
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
