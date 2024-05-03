import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> data = widget.data;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'This is Detail Page',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
