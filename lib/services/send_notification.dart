import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_time_minder/models/notif.dart';

class SendNotification {
  final int id;
  final String title;
  final String body;

  static final FlutterLocalNotificationsPlugin _defaultFln =
  FlutterLocalNotificationsPlugin();
  int generateRandomId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
  SendNotification({
    this.id = 0,
    this.title = 'TimeMinder',
    required this.body,
  }) {
    Notif.showBigTextNotification(
      id: id == 0 ? generateRandomId() : id,
      title: title,
      body: body,
      fln: _defaultFln,
    );
  }
}
