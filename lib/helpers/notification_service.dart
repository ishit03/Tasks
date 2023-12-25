import "package:awesome_notifications/awesome_notifications.dart";
import "package:flutter/material.dart";

class NotifService {
  initializeNotifications() async {
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: 'alert_notify',
          channelName: 'notify_channel',
          channelDescription: 'Alerting users about due tasks',
          importance: NotificationImportance.Default)
    ]);
  }

  scheduleNotification({required DateTime date, hour, minute, id, task}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'alert_notify',
            title:
                'Hurry Up!!! Your task is past due${Emojis.time_alarm_clock}',
            body: task,
            wakeUpScreen: true,
            fullScreenIntent: true,
            category: NotificationCategory.Message,
            icon: 'resource://mipmap/tasks_notification_icon',
            backgroundColor: Colors.black,
            color: Colors.black),
        actionButtons: [
          NotificationActionButton(
              key: 'alert_notify',
              label: 'Dismiss',
              actionType: ActionType.DisabledAction)
        ],
        schedule: NotificationCalendar(
            year: date.year,
            month: date.month,
            day: date.day,
            hour: hour,
            minute: minute,
            timeZone: AwesomeNotifications.localTimeZoneIdentifier));
  }

  cancelNotification(id) {
    AwesomeNotifications().cancel(id);
  }
}
