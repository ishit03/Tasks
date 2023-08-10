import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as latest;

class NotifService {
  FlutterLocalNotificationsPlugin notify = FlutterLocalNotificationsPlugin();
  initializeNotifications() async {
    configureLocalTimezone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/tasks_icon");

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await notify.initialize(initializationSettings);
  }

  scheduleNotification(
      {required int hour,
      required int minute,
      required int id,
      required String task}) async {
    await notify.zonedSchedule(
        id,
        'Hurry Up!!! Your task is pending',
        task,
        getTime(hour, minute),
        const NotificationDetails(
          android: AndroidNotificationDetails('channel id', 'channel name',
              channelDescription: 'channel desc',
              importance: Importance.max,
              priority: Priority.max,
              fullScreenIntent: true),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void configureLocalTimezone() async {
    latest.initializeTimeZones();
    final String local = await FlutterTimezone.getLocalTimezone();
    setLocalLocation(getLocation(local));
  }

  TZDateTime getTime(int hour, int minute) {
    final now = TZDateTime.now(local);
    final scheduleTime =
        TZDateTime(local, now.year, now.month, now.day, hour, minute);
    return scheduleTime;
  }
}
