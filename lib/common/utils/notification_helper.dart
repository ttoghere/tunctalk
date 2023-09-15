import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    var androidInit = const AndroidInitializationSettings("ic_launcher");
    var iosInit = const DarwinInitializationSettings();
    var initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }
}
