import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:time_minder/services/notif_service.dart';
import 'package:time_minder/widgets/modal_timer/cupertino_switch.dart';

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
      await Notif.initialize();
      await Notif.scheduleDailyNotification();
    } else {
      await AwesomeNotifications().cancelAllSchedules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enable Daily Notificatidsadason',
              style: TextStyle(fontSize: 18.0),
            ),
            CupertinoSwitchAdaptiveWidget(
              statusSwitch: _isNotificationEnabled,
              onChanged: _toggleNotification,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Notif.showInstantNotification();
              },
              child: Text('Show Instant Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
