import 'package:flutter/material.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
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
          'This is FAQ Page',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
