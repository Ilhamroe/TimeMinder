import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:time_minder/services/notif_service.dart';
import 'package:time_minder/widgets/modal_timer/cupertino_switch.dart';
import 'package:workmanager/workmanager.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isNotificationEnabled = false;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  void _checkNotificationStatus() async {
    bool isEnabled = await AwesomeNotifications().isNotificationAllowed();
    if (_isFirstBuild) {
      setState(() {
        _isFirstBuild = false;
      });
    } else {
      setState(() {
        _isNotificationEnabled = isEnabled;
      });
    }
  }

  Future<void> _toggleNotification(bool newValue) async {
    setState(() {
      _isNotificationEnabled = newValue;
    });
    if (newValue) {
      await NotifAwesome.initialize();
      await NotifAwesome.scheduleDailyNotification();
    } else {
      await AwesomeNotifications().cancelAllSchedules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notification Settings', textScaleFactor: 1.0),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enable Daily Notification',
                textScaleFactor: 1.0,
              ),
              CupertinoSwitchAdaptiveWidget(
                statusSwitch: _isNotificationEnabled,
                onChanged: _toggleNotification,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await NotifAwesome.showInstantNotification(
                      title: 'TimeMinder', body: 'Ini adalah instan Notif');
                },
                child: const Text('Show Instant Notification',
                    textScaleFactor: 1.0),
              ),
              SizedBox(height: 20),
              const Text(
                'Notif delay',
                textScaleFactor: 1.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Workmanager().registerOneOffTask(
                    '1',
                    'simpleTask',
                    initialDelay: Duration(seconds: 5),
                  );
                },
                child: const Text('Mulai Notifikasi Latar Belakang',
                    textScaleFactor: 1.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
