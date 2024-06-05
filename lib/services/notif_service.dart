import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class NotifAwesome {
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'notification_channel',
          channelName: 'notification Channel',
          channelDescription: 'notification channel',
          defaultColor: Colors.transparent,
          importance: NotificationImportance.Max,
          playSound: true,
        ),
      ],
    );
  }

  static Future<void> scheduleDailyNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'notification_channel',
        title: 'Daily Notification',
        body: 'Ini adalah notif daily',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 15,
        minute: 05,
        repeats: false,
        timeZone: 'Asia/Jakarta',
      ),
    );
  }

  static Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: 'notification_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        customSound: 'resource://raw/silent',
      ),
    );
  }

  static Future<void> showNotificationWithDelay({
    required String title,
    required String body,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    await showInstantNotification(
      title: title,
      body: body,
    );
  }
}
