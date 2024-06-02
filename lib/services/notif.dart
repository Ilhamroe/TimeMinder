import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notif {
  static Future<void> initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('mipmap/logo');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
    print('Initialization complete');
  }

  static Future<void> showBigTextNotification({
    int id = 0,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'you_can_name_it_whatever',
      'channel_name',
      playSound: false,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());
    await fln.show(id, title, body, not);
    print('Notification shown: $title - $body');
  }

  static Future<void> scheduleDailyNotification({
    int id = 1,
    required String title,
    required String body,
    required FlutterLocalNotificationsPlugin fln,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'daily_notification_channel_id',
      'daily_notification_channel_name',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: const DarwinNotificationDetails());

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day + 0, 12, 22, 0);

    print('Current Time: ${tz.TZDateTime.now(tz.local)}');
    print('Scheduled Time: $scheduledTime');

    await fln.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      not,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('Notification scheduled for: $scheduledTime');
  }
}