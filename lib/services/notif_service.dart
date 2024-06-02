import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class Notif {
  static Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'daily_notification_channel',
          channelName: 'Daily Notification Channel',
          channelDescription: 'Daily notification channel',
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
        channelKey: 'daily_notification_channel',
        title: 'Edit title di sini',
        body: 'Edit body di sini!',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        hour: 15,
        minute: 32,
        repeats: false,
        timeZone: 'Asia/Jakarta',
      ),
    );
  }

  static Future<void> showInstantNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: 'daily_notification_channel',
        title: 'Instan Notifikasi',
        body: 'Ini adalah notifikasi instan!',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
