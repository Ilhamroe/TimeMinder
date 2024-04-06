import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notif{
    static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
      var androidInitialize= const AndroidInitializationSettings('mipmap/logo');
      var iOSInitialize= const DarwinInitializationSettings();
      var initializationSettings= new InitializationSettings(android: androidInitialize);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }

    static Future showBigTextNotification({
      int id=0, 
      required String title, 
      required String body,
      var payload, 
      required FlutterLocalNotificationsPlugin fln
      }) async{
      AndroidNotificationDetails androidPlatformChannelSpecifics=
      const AndroidNotificationDetails(
        'you_can_name_it_whatever', 
        'channel_name',
        
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high,
        );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics, 
        iOS: const DarwinNotificationDetails()
    );
    await fln.show(id, title, body, not);
    }
}