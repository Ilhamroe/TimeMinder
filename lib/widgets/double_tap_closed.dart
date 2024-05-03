import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DoubleBackToCloseApp extends StatefulWidget {
  final Widget child;
  final String snackBarMessage;

  const DoubleBackToCloseApp({Key? key, required this.child, this.snackBarMessage = 'Tap back again to leave'})
      : super(key: key);

  @override
  _DoubleBackToCloseAppState createState() => _DoubleBackToCloseAppState();
}

class _DoubleBackToCloseAppState extends State<DoubleBackToCloseApp> {
  DateTime? _lastTimeBackButtonWasTapped;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_lastTimeBackButtonWasTapped == null ||
            DateTime.now().difference(_lastTimeBackButtonWasTapped!) > const Duration(milliseconds: 1500)) {
          _lastTimeBackButtonWasTapped = DateTime.now();
          Fluttertoast.showToast(msg: widget.snackBarMessage, fontSize: 14);
          return false;
        }
        exit(0);
      },
      child: widget.child,
    );
  }
}