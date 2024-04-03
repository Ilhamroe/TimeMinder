import 'package:flutter/material.dart';

class DetailListTimer extends StatefulWidget {
  const DetailListTimer({super.key});

  @override
  State<DetailListTimer> createState() => _DetailListTimerState();
}

class _DetailListTimerState extends State<DetailListTimer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail List Timer"),
      ),
    );
  }
}