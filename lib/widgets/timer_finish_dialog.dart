import 'package:flutter/material.dart';

class TimerFinishDialog extends StatelessWidget {
  final VoidCallback? onEndTimer;
  final String? title;
  final String? message;

  const TimerFinishDialog(
      {super.key, this.onEndTimer, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? 'Timer Selesai'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/cat_hello.png',
            fit: BoxFit.contain,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.width * 0.2,
          ),
          const SizedBox(height: 10),
          Text(message ?? 'Apakah Anda ingin menyelesaikan'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tidak'),
        ),
        TextButton(
          onPressed: () {
            onEndTimer?.call();
            Navigator.pop(context);
          },
          child: const Text('Ya'),
        ),
      ],
    );
  }
}
