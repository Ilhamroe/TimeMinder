import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/detail_custom_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  final List<Color> _customColors = [
    ripeMango,
    offOrange,
    offYellow,
    offGrey,
    heliotrope,
    merah,
    blueJeans,
    darkGrey,
    halfGrey,
    cetaceanBlue,
  ];
  Color _getRandomColor() {
    final Random random = Random();
    return _customColors[random.nextInt(_customColors.length)];
  }

  late List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = false;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  // refresh data
  void _refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
      duration: Duration(milliseconds: 500),
    ));
    _refreshData();
  }

  void _showModal(ModalCloseCallback onClose, [int? id]) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      _counter = existingData['time'] ?? 0;
      _counterBreakTime = existingData['rest'] ?? 0;
      _counterInterval = existingData['interval'] ?? 0;
    } else {
      // Jika data baru, reset nilai controller
      _namaTimerController.text = '';
      _deskripsiController.text = '';
      _counter = 0;
      _counterBreakTime = 0;
      _counterInterval = 0;
    }

    final newData = await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 170),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modal Custom Timer"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTimer(data: _allData[index]),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(15),
                  color: _getRandomColor(), // Set background color
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    subtitle: Text(_allData[index]['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_formatTime(_allData[index]['timer'] ?? 0) + " punya"),
                        Text(_allData[index]['rest'].toString() + "x rest, selama"),
                        Text(_allData[index]['interval'].toString() + "x"),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _showModal((int? id) {
                            // Lakukan sesuatu dengan ID yang dikembalikan
                          }, _allData[index]['id']), // Pass id ke _showModal
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteData(_allData[index]['id']),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal((int? id) {}),
        child: Icon(Icons.add),
      ),
    );
  }

  String _formatTime(int time) {
    int hours = time ~/ 60;
    int minutes = time % 60;
    int seconds = 0;

    String _padLeft(int value) {
      return value.toString().padLeft(2, '0');
    }

    return '${_padLeft(hours)}:${_padLeft(minutes)}:${_padLeft(seconds)}';
  }
}
