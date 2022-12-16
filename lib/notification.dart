import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  static final notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();
  static Future initNotification({bool? scheduled = false}) async {
    AndroidInitializationSettings initAndroidSettings =
        const AndroidInitializationSettings(
            '@mipmap/ic_stat_onesignal_default');
    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings();
    final settings = InitializationSettings(
        android: initAndroidSettings, iOS: iosInitializationSettings);
    return notification.initialize(settings,
        onSelectNotification: (String? payload) {
      onNotification.add(payload);
    });
  }

  static Future showNotification(
      {int? id, String? title, String? body, String? payload}) async {
    return notification.show(id!, title, body, await notificationDetails(),
        payload: payload);
  }

  static notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        enableLights: true,
        importance: Importance.max,
        largeIcon:
            DrawableResourceAndroidBitmap('@mipmap/ic_stat_onesignal_default'),
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
