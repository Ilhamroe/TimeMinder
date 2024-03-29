import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';

class CustomTimer extends StatefulWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  //databases
  List<Map<String, dynamic>> _allData = [];

  int _counter = 0;
  int _counterBreakTime = 0;
  int _counterInterval = 0;
  bool _isLoading = true;
  bool statusSwitch = false;
  bool hideContainer = true;

  TextEditingController _namaTimerController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();

  // show data
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // add data
  Future<void> _addData() async {
    await SQLHelper.createData(
        _namaTimerController.text,
        _deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
    _refreshData();
  }

  // edit data
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        _namaTimerController.text,
        _deskripsiController.text,
        _counter,
        _counterBreakTime,
        _counterInterval);
    _refreshData();
  }

  // delete data
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text("Data deleted"),
    ));
    _refreshData();
  }

  void _showModal(BuildContext context, int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _namaTimerController.text = existingData['title'];
      _deskripsiController.text = existingData['description'];
      _counter = existingData['time'];
      _counterBreakTime = existingData['rest'];
      _counterInterval = existingData['interval'];
    }

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        margin: EdgeInsets.only(top: 170),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
        ),
        child: DisplayModal(),
      ),
    );
  }

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
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.all(15),
                child: InkWell(
                  onTap: () {
                    _showModal(context, _allData[index]['id']);
                  },
                  child: ListTile(
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['title'],
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    subtitle: Text(_allData[index]['rest'].toString()),
                    trailing: Text(_allData[index]['timer'].toString()),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModal(context, null),
        child: Icon(Icons.add),
      ),
    );
  }
}
