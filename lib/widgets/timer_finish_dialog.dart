import 'package:flutter/material.dart';
import 'package:mobile_time_minder/theme.dart';

class TimerFinishDialog extends StatelessWidget {
  final VoidCallback? onEndTimer;
  final String? title;
  final String? message;

  const TimerFinishDialog(
      {super.key, this.onEndTimer, this.title, this.message});

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
                      onEndTimer?.call();
                      Navigator.pop(context);
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