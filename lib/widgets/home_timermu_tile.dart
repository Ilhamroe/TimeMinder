import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobile_time_minder/database/db_helper.dart';
import 'package:mobile_time_minder/pages/detail_custom_timer.dart';
import 'package:mobile_time_minder/pages/display_modal.dart';
import 'package:mobile_time_minder/theme.dart';

typedef ModalCloseCallback = void Function(int? id);

class HomeTimermuTile extends StatefulWidget {
  const HomeTimermuTile({super.key});

  @override
  State<HomeTimermuTile> createState() => _HomeTimermuTileState();
}

class _HomeTimermuTileState extends State<HomeTimermuTile> {
  final List<Color> _customColors = [
    blueJeans,
    ripeMango,
    darkGrey,
    heliotrope,
    red,
  ];

  //databases
  late List<Map<String, dynamic>> _allData = [];

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
    setState(() {
      _isLoading = true;
    });
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: EdgeInsets.all(8.0),
            shrinkWrap: true,
            itemCount: _allData.length,
            itemBuilder: (context, int index) {
              final color = _customColors[index % _customColors.length];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailTimer(data: _allData[index]),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 13.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: offOrange,
                  ),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        color: color,
                        child: SvgPicture.asset(
                          'assets/images/cat1.svg',
                          height: 30,
                        ),
                      ),
                    ),
                    title: Text(
                      _allData[index]['title'],
                      style: TextStyle(
                        fontFamily: 'Nunito-Bold',
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      _allData[index]['description'],
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    ),
                    trailing: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          _formatTime(_allData[index]['timer'] ?? 0),
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            color: darkGrey,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        SvgPicture.asset(
                          'assets/images/button.svg',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
